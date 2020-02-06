# frozen_string_literal: true

SocialWeb::Rack::Container.boot :social_web do
  start do
    require 'social_web/boot'
  end
end
