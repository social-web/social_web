# frozen_string_literal: true

module SocialWeb
  class Inbox
    class Create < Activity
      def call(create)
        SocialWeb['inbox'].for_actor(@actor).add(create)
      end
    end
  end
end
