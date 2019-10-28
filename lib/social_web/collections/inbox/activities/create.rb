# frozen_string_literal: true

module SocialWeb
  class Inbox
    class Create
      def call(create)
        SocialWeb['inbox'].for_actor().add(create)
      end
    end
  end
end
