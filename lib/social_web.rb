# frozen_string_literal: true

require 'bundler/setup'

require_relative './social_web/activity_streams_extension'
require 'social_web/collection'
require 'social_web/configuration'

module SocialWeb
  def self.process(activity_json, actor_iri, collection)
    raise unless %w[inbox outbox].include?(collection)

    activity = ActivityStreams.from_json(activity_json)
    actor = SocialWeb.container['repositories.actors'].find_by(iri: actor_iri)

    container['repositories.activities'].store(activity, actor, collection)
    handler = container.resolve(
      "collections.#{collection}.#{activity.type.downcase}"
    ) {}
    handler&.call(activity)
  end
end
