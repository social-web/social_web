# frozen_string_literal: true

module SocialWeb
  module Rack
    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield config
    end

    class Configuration
      attr_accessor :logger
    end
  end
end
