# frozen_string_literal: true

require 'social_web'
require 'social_web/app/repositories'
require 'social_web/app/routes'

module SocialWeb
  module App
    def self.new(app, *args, &block)
      Routes.new(app, *args, &block)
    end

    def self.call(env)
      Routes.call(env)
    end
  end
end
