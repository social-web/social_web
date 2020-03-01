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
      config.default_namespace = 'social_web'
      config.root = Pathname(File.join(__dir__, '..', '..')).realpath.freeze
      config.system_dir = 'system/social_web'
    end
  end
end
