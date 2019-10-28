# frozen_string_literal: true

module SocialWeb
  class Inbox
    class Accept
      def call(accept)
        follow = accept.object
        return unless SocialWeb['activities'].exists?(follow)

        SocialWeb['following'].for_actor(follow.actor).add(accept.actor)
      end
    end
  end
end
