# frozen_string_literal: true

ENV['DATABASE_URL'] = 'sqlite://social_web_dev.sqlite3'

require 'bundler/setup'
require 'social_web'
require 'social_web/rack'

Sequel.extension :migration

Sequel::Migrator.run(
  SocialWeb::Rack.db,
  './db/migrations',
  table: :social_web_schema_migrations
)

SocialWeb.configure do |config|
  config.container = SocialWeb::Rack::Container
end

class WardenUser
  WARDEN = Struct.new(:test) do
    def authenticate!
      true
    end

    def user
      user = Struct.new(:test) do
        def iri
          'http://localhost:9292'
        end
      end

      user.new
    end
  end


  def initialize(app)
    @app = app
  end

  def call(env)
    env['warden'] = WARDEN.new

    @app.call(env)
  end
end

use WardenUser

run SocialWeb::Rack::Routes.app.freeze
