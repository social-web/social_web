# frozen_string_literal: true

module SocialWeb
  module Web
    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield config
    end

    class Configuration
      attr_accessor :webfinger_resource
    end
  end
end
