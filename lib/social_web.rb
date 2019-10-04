# frozen_string_literal: true

require 'bundler/setup'

require_relative './activity_streams_extension'
require 'social_web/configuration'
require 'social_web/container'

module SocialWeb
  def self.container
    @container ||= SocialWeb::Container.merge(SocialWeb.config.container)
  end

  def self.process(activity_json, actor_iri, collection)
    raise unless %w[inbox outbox].include?(collection)

    activity = ActivityStreams.from_json(activity_json)
    actor = container['repositories.actors'].find_by(iri: actor_iri)

    container['repositories.activities'].store(activity, actor, collection)
    handler = container["collections.#{collection}.#{activity.type.downcase}"]
    handler&.call(activity)
  end
end
