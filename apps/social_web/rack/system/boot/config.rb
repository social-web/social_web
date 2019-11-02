# frozen_string_literal: true

SocialWeb::Rack::Container.boot :config do
  init do
    require 'social_web/rack/configuration'
  end
end
