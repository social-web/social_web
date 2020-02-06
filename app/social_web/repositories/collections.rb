# frozen_string_literal: true

module SocialWeb
  module Repositories
    class Collections
      def store_object_in_collection_for_iri(object:, collection:, actor:)
        return if stored?(object: object, collection: collection, actor: actor)

        collections.insert(
          type: collection,
          object_iri: object[:id],
          actor_iri: actor[:id],
          created_at: Time.now.utc
        )
      end

      def stored?(object:, collection:, actor:)
        found = collections.
          where(
            actor_iri: actor[:id],
            object_iri: object[:id],
            type: collection
          ).
          first
        !found.nil?
      end

      private

      def collections
        SocialWeb['relations.collections']
      end
    end
  end
end
