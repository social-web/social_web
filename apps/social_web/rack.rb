# frozen_string_literal: true

require_relative './rack/system/container'
require 'social_web/rack/configuration'

module SocialWeb
  module Rack
    def self.start!
      SocialWeb::Rack::Container.finalize!(freeze: false) do |container|
        container.start :config
        container.start :persistance
        container.start :social_web
        SocialWeb::Container.merge(container)
      end
    end
  end
end
