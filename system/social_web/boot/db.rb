# frozen_string_literal: true

SocialWeb::Container.boot :db do
  init do
    require 'sequel'

    register(:db, Sequel.connect(ENV['SOCIAL_WEB_DATABASE_URL']))
  end

  start do
    SocialWeb[:db].test_connection
  end

  stop do
    SocialWeb[:db].disconnect
  end
end
