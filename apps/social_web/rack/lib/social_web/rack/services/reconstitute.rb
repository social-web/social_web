# frozen_string_literal: true

module SocialWeb
  module Rack
    class Reconstitute
      DEPTH = 90
      COLLECTIONS = %i[replies].freeze
      RELATIONSHIPS = %i[actor attributedTo inReplyTo object target tag].freeze

      def call(obj)
        with_queue(obj) do |popped|
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
            queue_up += Array(child)
          end

          queue_up
        end

        obj
      end

      private

      attr_accessor :cache

      def cache
        @cache ||= {}
      end

      private

      def with_queue(initial, depth: DEPTH, &blk)
        loop_count = 0
        queue = [initial]
        while !queue.empty?
          popped = blk.call(queue.shift)
          if popped
            queue += Array(popped)
          else
            next
          end
          loop_count += 1
        end
      end
    end
  end
end
