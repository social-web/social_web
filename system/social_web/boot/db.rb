# frozen_string_literal: true

SocialWeb::Container.boot :db do
  init do
    require 'sequel'

    db = Sequel.connect(
      ENV['SOCIAL_WEB_DATABASE_URL'],
      loggers: SocialWeb['config'].loggers
    )

    db.extension :caller_logging

    register(:db, db)
  end

  start do
    SocialWeb[:db].test_connection
  end

  stop do
    SocialWeb[:db].disconnect
  end
end
