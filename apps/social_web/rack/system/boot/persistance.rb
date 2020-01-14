# frozen_string_literal: true

SocialWeb::Rack::Container.boot :persistance do
  init do
    require 'rom-sql'
    require 'rom-repository'

    require 'social_web/rack/relations/collections'
    require 'social_web/rack/relations/objects'
    require 'social_web/rack/relations/relationships'

    require 'social_web/rack/repositories/objects'
    require 'social_web/rack/repositories/collections'

    rom_configuration = ROM::Configuration.new(:sql, ENV['SOCIAL_WEB_DATABASE_URL'])
    rom_configuration.register_relation(SocialWeb::Rack::Relations::Collections)
    rom_configuration.register_relation(SocialWeb::Rack::Relations::Objects)
    rom_configuration.register_relation(SocialWeb::Rack::Relations::Relationships)
    rom_container = ROM.container(rom_configuration)
    rom_container.gateways[:default].use_logger(Logger.new(STDOUT))

    register(:db) { rom_container.gateways[:default] }

    # Relations
    register(:collections) { SocialWeb::Rack::Relations::Collections.new(rom_container.relations[:collections])}
    register(:objects) { SocialWeb::Rack::Relations::Objects.new(rom_container.relations[:objects])}
    register(:relationships) { SocialWeb::Rack::Relations::Relationships.new(rom_container.relations[:relationships])}

    # Repositories
    register(:objects_repo) { SocialWeb::Rack::Repositories::Objects.new(rom_container)}
    register(:collections_repo) { SocialWeb::Rack::Repositories::Collections.new(rom_container)}
  end
end
