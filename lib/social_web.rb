# frozen_string_literal: true

require 'activity_streams'
require 'http'
require 'rake'

require 'social_web/configuration'
require 'social_web/delivery'
require 'social_web/db'

ActivityStreams.internet.on

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


module ActivityStreams
  module Extensions
    module ActivityPub
      def self.included(base)
        base.class_eval do
          property :inbox
          property :outbox
        end
      end
    end
  end
end

ActivityStreams::Model.include ActivityStreams::Extensions::ActivityPub
