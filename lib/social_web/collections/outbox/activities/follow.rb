# frozen_string_literal: true

module SocialWeb
  module Outbox
    class Follow
      def call(follow)
        SocialWeb.config.container['services.delivery'].call(follow)
      end
    end
  end
end
