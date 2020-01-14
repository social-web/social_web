# frozen_string_literal: true

module SocialWeb
  module Rack
    class TraverseRelationships
      RELATIONSHIPS = %i[actor attributedTo inReplyTo object target tag].freeze

      # Take an ActivityStreams object and traverse the given relationship,
      # breadth-first. Call the given block with any relationship found.
      # @params
      #   obj: an ActivityStreams object
      #   relationship: Property to traverse
      #   blk: block to call on any relationship found, and which returns
      #     a child to add to the queue
      def call(obj, relationships: RELATIONSHIPS, depth: 20, &blk)
        queue = [obj]
        loop_count = 0

        while !queue.empty? && loop_count <= depth
          o = queue.shift

          relationships.each do |rel|
            child = o[rel]
            next unless child

            child = blk.call(o, rel, child) if blk

            case child
            when Array then queue += child.compact
            else queue << child
            end
          end

          loop_count += 1
        end

        obj
      end

      private

      def is_iri?(val)
        val.is_a?(String) && val.match?(/^#{URI.regexp}$/)
      end

      def loop_count
        @loop_count ||= 0
      end
    end
  end
end
