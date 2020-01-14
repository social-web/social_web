# frozen_string_literal: true

SocialWeb::Rack::Container.boot :social_web do
  init do
    require 'social_web'
  end

  start do
    require 'social_web/boot'
  end
end
