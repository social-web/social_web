# frozen_string_literal: true

module SocialWeb
  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield config
  end

  class Configuration
    attr_accessor :database_url,
      :private_key,
      :public_key,
      :actor,
      :webfinger_resource

    def database_url=(url)
      @database_url ||= url
    end
  end
end
