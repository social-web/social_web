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

      require 'social_web/rack/configuration'
      require 'social_web/rack/routes'

      require 'social_web/rack/collections/following'
      register(:following) { Collections::Following }

      # Repositories
      require 'social_web/rack/repositories'
      register(:activities) { Repositories::Activities.new }
      register(:actors) { Repositories::Actors.new }
      register(:keys) { Repositories::Keys.new }

      # Services
      require 'social_web/rack/services'
      register(:delivery) { Rack::Delivery.new }
      register(:dereference) { Rack::Dereference }
    end
  end
end
