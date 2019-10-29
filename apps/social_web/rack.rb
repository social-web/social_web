# frozen_string_literal: true

require_relative './rack/system/container'

module SocialWeb
  module Rack
    def self.start!
      SocialWeb::Rack::Container.finalize! do |container|
        require 'rake'
        Rake.load_rakefile 'social_web/rack/tasks/db.rake'

        container.start :persistance

        container.init :social_web
        SocialWeb::Container.merge(container)
        container.start :social_web
      end
    end
  end
end
