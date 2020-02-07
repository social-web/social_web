# frozen_string_literal: true

module SocialWeb
  module Rack
    class Reconstitute
      COLLECTIONS = %i[replies].freeze
      RELATIONSHIPS = %i[actor attributedTo inReplyTo object target tag].freeze

      def call(obj)
        queue(obj) do |popped|
          # Keep track of the items we'd like to add to the queue
          queue_up = []

          popped = SocialWeb['objects'].get_by_iri(popped) if popped.is_a?(String)
          next unless popped

          COLLECTIONS.each do |collection|
            items = SocialWeb['traverse_collection'].call(popped[collection])
            items = items.map do |i|
              i = SocialWeb['objects'].get_by_iri(i) if i.is_a?(String)
              i
            end

            obj[collection][:items] ||= []
            obj[collection][:items] += items

            queue_up += items
          end

          RELATIONSHIPS.each do |relationship|
            child = popped[relationship]
            child = SocialWeb['objects'].get_by_iri(child) if child.is_a?(String)
            popped[relationship] = child
            queue_up += Array(child)
          end

          queue_up
        end

        obj
      end

      private

      def queue(initial, depth: SocialWeb['config'].max_depth, &blk)
        loop_count = 0
        queue = [initial]
        while !queue.empty? && loop_count < DEPTH
          queue += Array(blk.call(queue.shift))
          loop_count += 1
        end
      end
    end
  end
end
