# frozen_string_literal: true

module SocialWeb
  module Repositories
    class Relationships
      def get(parent:, child:, prop:)
        relationships.first(
          type: prop.to_s,
          parent_iri: parent[:id],
          child_iri: child[:id],
        )
      end

      def store(parent:, child:, property:)
        return if stored?(parent: parent, child: child, prop: property) ||
          !parent[:id] || !child[:id]

        relationships.insert(
          type: property.to_s,
          parent_iri: parent[:id],
          child_iri: child[:id],
          created_at: Time.now.utc
        )
      end

      def stored?(parent:, child:, prop:)
        !get(parent: parent, child: child, prop: prop).nil?
      end

      private

      def relationships
        SocialWeb['relations.relationships']
      end
    end
  end
end
