# frozen_string_literal: true

ENV['DATABASE_URL'] = 'sqlite://social_web_dev.sqlite3'

require 'bundler/setup'
require 'social_web'
require_relative './apps/web'

Sequel.extension :migration

Sequel::Migrator.run(
  SocialWeb::Web.db,
  './db/migrations',
  table: :social_web_schema_migrations
)

SocialWeb.configure do |config|
  config.container = SocialWeb::Web::Container
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

run SocialWeb::Web::Routes.app.freeze
