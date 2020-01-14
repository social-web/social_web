# frozen_string_literal: true

module SocialWeb
  module Rack
    module Relations
      class Collections < ROM::Relation[:sql]
        schema(:social_web_collections, as: :collections, infer: true) do
          attribute :actor_iri, Types::String
          attribute :object_iri, Types::String
          primary_key :actor_iri, :object_iri

          associations do
            belongs_to :objects, as: :object, foreign_key: :object_iri
            belongs_to :objects, as: :actor, foreign_key: :actor_iri
          end
        end

        def by_actor_iri(actor_iri)
          where(Sequel[:social_web_collections][:actor_iri] => actor_iri)
        end

        def by_object_iri(object_iri)
          where(Sequel[:social_web_collections][:object_iri] => object_iri)
        end

        def by_type(type)
          where(Sequel[:social_web_collections][:type] => type)
        end
      end
    end
  end
end
