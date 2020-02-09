# frozen_string_literal: true

module SocialWeb
  module Collections
    class Inbox < SocialWeb::Collection
      TYPE = 'INBOX'

      def process(activity)
        add(activity)

        case activity[:type]
        when 'Create' then return
        when 'Update'
          SocialWeb['repositories.objects'].replace(activity[:object])
        when 'Delete'
          SocialWeb['repositories.objects'].delete(activity[:object])
        when 'Accept'
          if SocialWeb['collections.outbox'].for_actor(actor).include?(activity[:object])
            SocialWeb['collections.following'].for_actor(actor).add(activity[:actor])
          end
        end
      end
    end
  end
end
