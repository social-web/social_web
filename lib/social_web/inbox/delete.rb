# frozen_string_literal: true

module SocialWeb
  class Inbox
    class Delete < Activity
      def call(create)
        SocialWeb['inbox'].for_actor(@actor).remove(create)
      end
    end
  end
end
