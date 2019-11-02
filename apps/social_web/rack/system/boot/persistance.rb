# frozen_string_literal: true

SocialWeb::Rack::Container.boot :persistance do
  init do
    require 'sequel'
    require 'dry/monads'
    require 'dry/monads/result'
    require 'social_web/rack/persistance'

    register(:db, SocialWeb::Rack.db)

    # Repositories
    require 'social_web/rack/repositories'
    register(:activities) { SocialWeb::Rack::Repositories::Activities.new }
    register(:actors) { SocialWeb::Rack::Repositories::Actors.new }
    register(:keys) { SocialWeb::Rack::Repositories::Keys.new }
  end

  start do
    SocialWeb::Rack.db.test_connection
  end

  stop do
    SocialWeb::Rack.db.disconnect
  end
end
