# frozen_string_literal: true

SocialWeb::Container.boot :configuration do
  init do
    require 'social_web/configuration'
    register(:config, SocialWeb.configuration)

    SocialWeb.configure do |config|
      config.max_depth = 200
    end
  end
end
