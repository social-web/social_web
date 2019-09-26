# frozen_string_literal: true

require 'bundler/setup'

require 'rake'

require_relative './activity_streams_extension'
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
    @container ||= SocialWeb::Container.merge(SocialWeb.config.container)
  end

  def self.process(activity_json, actor_iri, collection)
    raise unless %w[inbox outbox].include?(collection)

    activity = ActivityStreams.from_json(activity_json)
    actor = container['repositories.actors'].find_by(iri: actor_iri)

    act = Activity.new(activity, actor, collection)

    container['repositories.activities'].store(act)
    container["collections.#{collection}.#{activity.type.downcase}"].call(act)
  end
end

require 'social_web/collections/outbox/activities/follow'
require 'social_web/collections/inbox/activities/accept'
