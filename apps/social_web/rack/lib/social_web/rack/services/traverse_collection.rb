# frozen_string_literal: true

module SocialWeb
  module Rack
    class TraverseCollection
      DEFAULT_DEPTH = 20

      # Take an ActivityStreams object and traverse its relationships. Call the given block with
      # any relationship found.
      # @params
      #   obj: an ActivityStreams object
      #   blk: block to call on any relationship found
      def call(obj, collection:, depth: DEFAULT_DEPTH, &blk)
        queue = [obj]

        while !queue.empty? && loop_count <= DEFAULT_DEPTH
          obj = queue.pop
          col = obj[collection]
          next unless col

          items = []

          col = SocialWeb['objects'].get_by_iri(col) if col.is_a?(String)
          items += col[:items] if col[:items]

          if col[:first]
            items += get_items(col[:first])
            col = SocialWeb['objects'].get_by_iri(col[:first][:next])
          end

          items += get_items(col)

          next unless items

          items = items.map do |itm|
            itm.is_a?(String) ? SocialWeb['objects'].get_by_iri(itm) : itm
          end

          blk.call(obj, collection, items) if blk

          queue += items
        end
      end

      private

      attr_accessor :loop_count

      def get_items(collection)
        case collection[:type]
        when 'Collection', 'CollectionPage'
          collection[:items]
        when 'OrderedCollection', 'OrderedCollectionPage'
          collection[:ordered_items]
        end
      end

      def loop_count
        @loop_count ||= 0
      end
    end
  end
end
