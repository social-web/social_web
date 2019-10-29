# frozen_string_literal: true

module SocialWeb
  class Outbox
    class Follow < Activity
      def call(follow)
        SocialWeb.container['services.delivery'].call(follow)
      end
    end
  end
end
