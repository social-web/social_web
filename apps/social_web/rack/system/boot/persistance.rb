# frozen_string_literal: true

SocialWeb::Rack::Container.boot :persistance do
  init do
    require 'sequel'
    require 'dry/monads'
    require 'dry/monads/result'
    require 'social_web/rack/persistance'

    register(:db, SocialWeb::Rack.db)

    require 'social_web/rack/relations/objects'
    register(:objects_rel) { SocialWeb::Rack::Relations::Objects }

    require 'social_web/rack/repositories/keys'
    register(:keys) { SocialWeb::Rack::Repositories::Keys.new }

    require 'social_web/rack/repositories/collections'
    register(:collections) { SocialWeb::Rack::Repositories::Collections.new }

    require 'social_web/rack/services/reconstitute'
    register(:reconstitute) { SocialWeb::Rack::Reconstitute.new }

    require 'social_web/rack/repositories/relationships'
    register(:relationships) { SocialWeb::Rack::Repositories::Relationships.new }

    require 'social_web/rack/repositories/objects'
    register(:objects_repo) { SocialWeb::Rack::Repositories::Objects.new }

  end

  start do
    SocialWeb::Rack.db.test_connection
  end

  stop do
    SocialWeb::Rack.db.disconnect
  end
end
