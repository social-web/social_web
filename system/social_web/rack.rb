# frozen_string_literal: true

require_relative './rack/container'

module SocialWeb
  module Rack
    def self.[](key)
      SocialWeb::Rack::Container.resolve(key)
    end
  end
end

SocialWeb::Rack::Container.finalize! do |container|
  require 'rake'
  Rake.load_rakefile 'social_web/rack/tasks/db.rake'

  container.start :persistance

  container.init :social_web
  SocialWeb::Container.merge(container)
  container.start :social_web
end
