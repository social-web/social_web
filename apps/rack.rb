# frozen_string_literal: true

require 'social_web'

# require 'rake'
# Rake.load_rakefile 'rack/tasks/db.rake'

require_relative './rack/configuration'
require_relative './rack/container'
require_relative './rack/collections/following'
require_relative './rack/persistance'
require_relative './rack/repositories'
require_relative './rack/routes'

SocialWeb.config.container = SocialWeb::Rack::Container

module SocialWeb
  module Rack
    def self.new(*args, **kwargs)
      SocialWeb::Rack::Routes.app
    end
  end
end
