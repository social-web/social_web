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

          col = SocialWeb['objects'].get_by_iri(col) if col.is_a?(String)

          if col[:first]
            col = SocialWeb['objects'].get_by_iri(col[:first][:next])
          end

          items = case col[:type]
          when 'Collection', 'CollectionPage'
            col[:items]
          when 'OrderedCollection', 'OrderedCollectionPage'
            col[:ordered_items]
          end

          next unless items

          items = items.map do |itm|
            itm.is_a?(String) ? SocialWeb['objects'].get_by_iri(itm) : itm
          end

          blk.call(obj, collection, items) if blk

          queue += items
        end

        collection
      end

      private

      attr_accessor :loop_count

      def loop_count
        @loop_count ||= 0
      end
    end
  end
end
