# frozen_string_literal: true

SocialWeb::Rack::Container.boot :persistance do
  init do
    require 'sequel'
    require 'social_web/rack/persistance'

    register(:db, SocialWeb::Rack.db)
  end

  start do
    SocialWeb::Rack.db.test_connection
  end

  stop do
    SocialWeb::Rack.db.disconnect
  end
end
