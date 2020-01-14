# frozen_string_literal: true

require 'dry/system/container'

module SocialWeb
  module Rack
    def self.[](key)
      container[key]
    end

    def self.container
      @container ||= Container
    end

    class Container < Dry::System::Container
      configure do |config|
        config.auto_register = 'lib'
        config.root = Pathname(File.join(__dir__, '..')).realpath.freeze
      end

      load_paths! 'lib'
      require 'social_web/rack/services/traverse_relationships'
      register('rack.traverse_relationships') { SocialWeb::Rack::TraverseRelationships.new }

      require 'social_web/rack/services/traverse_collection'
      register('rack.traverse_collection') { SocialWeb::Rack::TraverseCollection.new }
    end
  end
end
