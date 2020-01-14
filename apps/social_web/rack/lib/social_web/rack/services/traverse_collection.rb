# frozen_string_literal: true

module SocialWeb
  module Rack
    class TraverseCollections
      COLLECTIONS = %i[inbox outbox replies].freeze

      def call(obj, collections: COLLECTIONS)
        loop_count = 0
        queue = [col]
        items = []
        cols = Set.new

        while !queue.empty? && loop_count <= 20
          col = queue.shift
          break if cols.include?(col) || !col

          collections.each do |col|
            if col.is_a?(String)
              col = SocialWeb['objects'].get_by_iri(col)
            end
            cols << col[:id]

            case col[:type]
            when 'Collection', 'OrderedCollection'
              if first = col[:first]
                queue << first
              end
            when 'CollectionPage', 'OrderedCollectionPage'
              if nxt = col[:next]
                queue << nxt
              end
            end

            items += Array(col[:items])
          end
        end

        items
      end
    end
  end
end
