# frozen_string_literal: true

SocialWeb::Container.boot :configuration do
  init do
    require 'dry-configurable'

    require 'social_web/configuration'
    register(:config, SocialWeb.config)
  end
end
