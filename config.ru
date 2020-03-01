# frozen_string_literal: true

ENV['SOCIAL_WEB_ACTIVITY_PUB_DATABASE_URL'] = 'sqlite://social_web_dev.sqlite3'

require 'bundler/setup'
require 'social_web/boot'

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
use SocialWeb::ActivityPub::Rack

run ->() { raise }