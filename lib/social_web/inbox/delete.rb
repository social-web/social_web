# frozen_string_literal: true

module SocialWeb
  class Inbox
    class Delete < Activity
      def call(delete)
        SocialWeb['inbox'].for_actor(@actor).remove(delete.object)
      end
    end
  end
end
