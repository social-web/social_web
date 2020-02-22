# frozen_string_literal: true

module SocialWeb
  module Repositories
    class Collections
      def get_collection_for_actor(actor:, collection:)
        items = SocialWeb['relations.collections'].
          by_actor_iri(actor[:id]).
          by_type(collection).
          with_objects.
          order(Sequel.desc(Sequel[:social_web_collections][:created_at])).
          to_a
        ActivityStreams.ordered_collection(
          id: [actor[:id], collection].join('/'),
          items: items.map { |i| ActivityStreams.from_json(i[:json])},
          name: collection
        )
      end

      def store_object_in_collection_for_actor(object:, collection:, actor:)
        return if stored?(object: object, collection: collection, actor: actor)

        collections.insert(
          type: collection.to_s,
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
            type: collection.to_s
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
