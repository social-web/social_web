# frozen_string_literal: true

module SocialWeb
  module Collections
    class Inbox < SocialWeb::Collection
      SIDE_EFFECTS = [
        'Create' => ->(create) {
          [create[:actor], create[:object]].each { |o| SocialWeb['objects_repo'].store(o) }
        },
        'Follow' => ->(follow) {
          SocialWeb['followers'].for_actor(actor).add(follow[:object])
        }
      ]
      TYPE = 'INBOX'

      def process(activity)
        unless SocialWeb['collections.following'].for_actor(actor).includes?(activity[:actor])
          return
        end

        add(activity)

        case activity[:type]
        when 'Create' then return
        when 'Update'
          SocialWeb['repositories.objects'].replace(activity[:object])
        when 'Delete'
          SocialWeb['repositories.objects'].delete(activity[:object])
        when 'Accept'
          if SocialWeb['collections.outbox'].for_actor(actor).includes?(activity[:object])
            SocialWeb['collections.following'].for_actor(actor).add(activity[:actor])
          end
        end
      end
    end
  end
end
