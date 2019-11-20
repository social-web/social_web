# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Collections
        def get_collection_by_iri(collection:, iri:)
          found = SocialWeb::Rack.db[:social_web_objects].
            join_table(
              :inner,
              :social_web_collections,
              { object_iri: :iri }
            ).
            where(Sequel[:social_web_collections][:actor_iri] => iri)
          return unless found

          collection = ActivityStreams.collection
          collection.items = found.map { |obj| ActivityStreams.from_json(obj[:json]) }
          collection
        end

        def store_object_in_collection_for_iri(object:, collection:, iri:)
          SocialWeb::Rack.db[:social_web_collections].insert(
            type: collection,
            actor_iri: iri,
            object_iri: object.id,
            created_at: Time.now.utc
          )
        end
      end
    end
  end
end
