# frozen_string_literal: true

module SocialWeb
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  class Configuration
    attr_accessor :database_url, :private_key, :webfinger_resource

    def database_url=(url)
      @database_url ||= url
    end
  end
end
