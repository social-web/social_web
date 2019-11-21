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

      require 'social_web/rack/repositories/keys'
      register(:keys) { SocialWeb::Rack::Repositories::Keys.new }

      require 'social_web/rack/repositories/collections'
      register(:collections) { SocialWeb::Rack::Repositories::Collections.new }

      require 'social_web/rack/services/traverse'
      register(:traverse) { SocialWeb::Rack::Traverse.new }
    end
  end
end
