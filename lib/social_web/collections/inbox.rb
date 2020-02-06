# frozen_string_literal: true

module SocialWeb
  module Collections
    class Inbox < SocialWeb::Collection
      SIDE_EFFECTS = [
        'Create' => ->(create) {
          [create.actor, create.object].each { |o| SocialWeb['objects_repo'].store(o) }
        },
        'Follow' => ->(follow) {
          SocialWeb['followers'].for_actor(actor).add(follow.object)
        }
      ]
      TYPE = 'INBOX'

      def add(obj)
        if Following.for_actor(actor).includes?(obj.actor)
          store_obj_in_collection(obj)
        end
      end
    end
  end
end
