# frozen_string_literal: true

module SocialWeb
  module Rack
    module Relations
      class Relationships < ROM::Relation[:sql]
        schema(:social_web_relationships, as: :relationships, infer: true) do
          attribute :parent_iri, Types::String
          attribute :child_iri, Types::String
          primary_key :parent_iri, :child_iri

          associations do
            belongs_to :objects, as: :parent, foreign_key: :parent_iri
            belongs_to :objects, as: :child, foreign_key: :child_iri
          end
        end

        def by_type(type)
          where(Sequel[:social_web_relationships][:type] => type)
        end
      end
    end
  end
end
