# frozen_string_literal: true

require 'dry/system/container'

module SocialWeb
  def self.[](key)
    container[key]
  end

  def self.container
    @container ||= Container
  end

  class Container < Dry::System::Container
    configure do |config|
      config.auto_register = ['lib']
      config.default_namespace = 'social_web'
      config.root = Pathname(File.join(__dir__, '..', '..')).realpath.freeze
      config.system_dir = 'system/social_web'
    end

    load_paths! 'lib'
    load_paths! 'app'

    require_relative './configuration'
    register(:config, SocialWeb.configuration)
    SocialWeb.configure do |config|
      config.max_depth = Float::INFINITY
    end
  end
end
