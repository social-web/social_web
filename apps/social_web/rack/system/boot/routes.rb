# frozen_string_literal: true

SocialWeb::Rack::Container.boot :routes do
  init do
    require 'roda'
    require 'slim'
    require 'tilt'
  end
end
