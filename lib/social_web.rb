# frozen_string_literal: true

require 'activity_streams'
require 'http'
require 'rake'

require 'social_web/configuration'
require 'social_web/delivery'
require 'social_web/db'

module SocialWeb
  def self.new(app, *args, &block)
    load!
    Routes.new(app, *args, &block)
  end

  def self.call(env)
    load!
    Routes.call(env)
  end

  def self.load!
    require 'social_web/app'
  end
end
