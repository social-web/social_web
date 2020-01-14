# frozen_string_literal: true

require 'bundler/setup'

require 'social_web/collection'

module SocialWeb
  def self.process(activity_json, actor_iri, collection)
    raise unless %w[inbox outbox].include?(collection)

    activity = ActivityStreams.from_json(activity_json)
    actor = container['objects_repo'].get_by_iri(actor_iri)

    binding.irb

    [activity, actor].each { |obj| container['objects_repo'].deep_add(obj) }

    container['collections_repo'].store_object_in_collection_for_iri(
      object: activity,
      collection: collection,
      iri: actor_iri
    )
  end
end
