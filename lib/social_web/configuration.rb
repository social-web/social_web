# frozen_string_literal: true

module SocialWeb
  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield config
  end

  class Configuration
    attr_accessor :container

    def container
      @container ||= SocialWeb::Container
    end
  end
end
