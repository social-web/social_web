# frozen_string_literal: true

require 'roda'

require 'social_web/exceptions'
require 'social_web/configuration'
require 'social_web/hooks'
require 'social_web/routes'

module SocialWeb
  def self.new(app, *args, &block)
    Routes.new(app, *args, &block)
  end

  def self.call(env)
    Routes.call(env)
  end
end
