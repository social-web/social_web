# frozen_string_literal: true

require_relative './rack/system/container'
require 'social_web/rack/configuration'

module SocialWeb
  module Rack
    def self.db
      @db ||= Sequel.connect(ENV['SOCIAL_WEB_DATABASE_URL'])
    end

    def self.start!
      SocialWeb::Rack::Container.finalize!(freeze: false) do |container|
        container.start :activity_streams
        container.start :config
        container.start :persistance
        container.start :social_web
        SocialWeb::Container.merge(container)
      end
    end
  end
end
