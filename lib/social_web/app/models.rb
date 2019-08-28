# frozen_string_literal: true

Sequel::Model.plugin :timestamps

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

require 'social_web/app/models/activities/create'
require 'social_web/app/models/activities/follow'

require 'social_web/app/models/activity'
require 'social_web/app/models/object'
require 'social_web/app/models/object_version'
