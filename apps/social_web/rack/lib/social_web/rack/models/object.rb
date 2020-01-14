module SocialWeb
  module Rack
    class Object  < ActivityStreams::Object
      DEPTH = 90.freeze

      # @return ActivityStreams::Collection
      def inbox
        ActivityStreams::Collection
      end

      # @return Hash representing tree of replies
      def replies
        hash = { self => [] }
        obj = self
        with_queue do
          SocialWeb['traverse_collection'].call(
            obj,
            collection: 'replies'
          ) do |o, collection, items|
            hash[o] ||= []
            hash[o] += items.map(&:id)
          end
        end
        hash
      end

      private

      def with_queue(depth: DEPTH, &blk)
        loop_count = 0
        queue = [self]
        while !queue.empty? && loop_count <= DEPTH
          queue << blk.call(queue.pop)
          loop_count += 1
        end
      end
    end
  end
end
