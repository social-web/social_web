# frozen_string_literal: true

SocialWeb::Rack::Container.boot :activity_streams do
  init do
    require 'activity_streams'

    require 'social_web/rack/models/object'
    register(:object) { SocialWeb::Rack::Object }
  end
end
