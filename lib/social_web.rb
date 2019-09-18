# frozen_string_literal: true

require 'bundler/setup'

require 'activity_streams'
require 'dry-auto_inject'
require 'rake'

require 'social_web/configuration'
require 'social_web/container'

module SocialWeb
  Activity = Struct.new(:activity, :actor, :collection) do
    def id
      activity.id
    end

    def type
      activity.type
    end
  end

  def self.container
    @container ||= Dry::AutoInject(SocialWeb.config.container)
  end

  def self.process(activity, actor, collection)
    act = Activity.new(activity, actor, collection)
    SocialWeb.config.container['repositories.activities'].store(act)

    case act.collection
    when 'outbox'
      case act.type
      when 'Follow' then Outbox::Follow.new.call(act)
      end
    when 'inbox'
      case act.type
      when 'Accept' then Inbox::Accept.new.call(act)
      end
    end
  end
end

require 'social_web/collections/outbox/activities/follow'
require 'social_web/collections/inbox/activities/accept'

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
