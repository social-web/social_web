# frozen_string_literal: true

module SocialWeb
  module Rack
    class Traverse
      # Take an ActivityStreams object and traverse the given relationship,
      # breadth-first. Call the given block with any relationship found.
      # @params
      #   obj: an ActivityStreams object
      #   relationship: Property to traverse
      #   blk: block to call on any relationship found
      def call(obj, relationship:, &blk)
        queue = [obj]

        while !queue.empty? && loop_count <= 20
          obj = queue.pop
          child = obj[relationship]
          next unless child

          child = SocialWeb['objects'].get_by_iri(child) if is_iri?(child)

          case child
          when Array
            queue += child.compact
            next
          when ActivityStreams::Model then queue << child
          else
            raise 'Expected an array or ActivityStreams::Model'
          end

          blk.call(obj, relationship, child) if blk

          @loop_count += 1
        end
      end

      private

      attr_accessor :loop_count

      def is_iri?(val)
        val.is_a?(String) && val.match?(/^#{URI.regexp}$/)
      end

      def loop_count
        @loop_count ||= 0
      end
    end
  end
end
