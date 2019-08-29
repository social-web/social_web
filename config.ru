# frozen_string_literal: true

require 'bundler/setup'
require 'social_web'

SocialWeb.configure do |config|
  config.database_url = 'sqlite://social_web_dev.sqlite3'
end

Sequel.extension :migration, :core_extensions
Sequel::Migrator.run(
  SocialWeb.db,
  './lib/social_web/db/migrations',
  table: :social_web_schema_migrations
)

SocialWeb.load!

run SocialWeb::Routes.app.freeze