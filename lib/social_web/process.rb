# frozen_string_literal: true

require 'bundler/setup'

require 'social_web/activity_streams_extension'
require 'social_web/collection'

module SocialWeb
  def self.process(activity_json, actor_iri, collection)
    raise unless %w[inbox outbox].include?(collection)

    activity = ActivityStreams.from_json(activity_json)
    actor = SocialWeb.container['actors'].find_by(iri: actor_iri)

    container['activities'].store(activity, actor, collection)
    handler = container.resolve(
      "collections.#{collection}.#{activity.type.downcase}"
    ) {}
    handler&.for_actor(actor).call(activity)
  end
end
