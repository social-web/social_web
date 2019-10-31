# frozen_string_literal: true

module SocialWeb
  class Inbox
    class Accept < Activity
      def call(accept)
        SocialWeb['following'].for_actor(@actor).add(accept.actor)
      end
    end
  end
end
