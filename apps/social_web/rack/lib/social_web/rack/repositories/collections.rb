# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Collections
        def get_collection_for_iri(collection:, iri:)
          deleted = SocialWeb::Rack.
            db[:social_web_objects].
            select(:child_iri).
            join_table(
              :inner,
              :social_web_relationships,
              { parent_iri: :iri }
            ).
            where(
              Sequel[:social_web_objects][:type] => 'Delete',
              Sequel[:social_web_relationships][:type] => 'object'
            )

          found = SocialWeb::Rack.
            db[:social_web_objects].
            join_table(
              :inner,
              :social_web_relationships,
              { parent_iri: :iri }
            ).
            where(
              Sequel[:social_web_objects][:type] => 'Create',
              Sequel[:social_web_relationships][:type] => 'object'
            ).
            order(Sequel.desc(Sequel[:social_web_objects][:created_at]))

          collection = ActivityStreams.collection
          collection.items = found.map do |record|
            obj = ActivityStreams.from_json(record[:json])
            SocialWeb['reconstitute'].call(obj)
            obj
          end

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
