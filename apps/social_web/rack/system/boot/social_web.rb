# frozen_string_literal: true

SocialWeb::Rack::Container.boot :social_web do
  init do
    require 'social_web'
  end

  start do
    # Repositories
    require 'social_web/rack/repositories/objects'
    register(:objects) { SocialWeb::Rack::Repositories::Objects.new }

    require 'social_web/boot'
  end
end
