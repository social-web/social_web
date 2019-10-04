# frozen_string_literal: true

require 'social_web'

require 'rake'
Rake.load_rakefile 'social_web/rack/tasks/db.rake'

require 'social_web/rack/configuration'
require 'social_web/rack/container'
require 'social_web/rack/collections/following'
require 'social_web/rack/persistance'
require 'social_web/rack/repositories'
require 'social_web/rack/routes'

SocialWeb.config.container = SocialWeb::Rack::Container

module SocialWeb
  module Rack
    def self.new(*args, **kwargs)
      SocialWeb::Rack::Routes.app
    end
  end
end
