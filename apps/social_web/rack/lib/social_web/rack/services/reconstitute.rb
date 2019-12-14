# frozen_string_literal: true

module SocialWeb
  module Rack
    class Reconstitute
      COLLECTIONS = %i[replies].freeze
      RELATIONSHIPS = %i[actor attributedTo inReplyTo object target tag].freeze

      def call(obj)
        COLLECTIONS.each do |col|
          SocialWeb['traverse_collection'].call(
            obj,
            collection: col
          ) do |o, collection, items|
            obj[collection][:items] ||= []
            obj[collection][:items] += items
          end
        end

        RELATIONSHIPS.each do |rel|
          SocialWeb::Rack['traverse'].call(
            obj,
            relationship: rel
          ) { |parent, rel, child| parent[rel] = child }
        end

        obj
      end
    end
  end
end
