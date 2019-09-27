# frozen_string_literal: true

require 'social_web'

require 'rake'
Rake.load_rakefile 'web/tasks/db.rake'

require_relative './web/configuration'
require_relative './web/container'
require_relative './web/collections/following'
require_relative './web/persistance'
require_relative './web/repositories'
require_relative './web/routes'

SocialWeb.config.container = SocialWeb::Web::Container

module SocialWeb
  module Web
    def self.new(*args, **kwargs)
      SocialWeb::Web::Routes.app
    end
  end
end
