# frozen_string_literal: true

module SocialWeb
  class Inbox
    class Accept
      def call(accept)
        follow = accept.activity.object
        return unless SocialWeb.container['repositories.activities'].exists?(follow)

        SocialWeb.container['collections.following'].
          for_actor(follow.actor).
          add(accept.actor)
      end
    end
  end
end
