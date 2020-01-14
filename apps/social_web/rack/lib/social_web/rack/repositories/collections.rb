# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Collections
        def store_object_in_collection_for_iri(object:, collection:, actor:)
          return if stored?(object: object, collection: collection, actor: actor)

          collections.insert(
            type: collection,
            object_iri: object.id,
            actor_iri: actor.id,
            created_at: Time.now.utc
          )
        end

        private

        def stored?(object:, collection:, actor:)
          found = collections.
            by_object_iri(object.id).
            by_actor_iri(actor.id).
            by_type(collection).
            one
          !found.nil?
        end
      end
    end
  end
end
