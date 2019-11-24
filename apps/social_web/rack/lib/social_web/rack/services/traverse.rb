# frozen_string_literal: true

module SocialWeb
  module Rack
    # Take an ActivityStreams object and traverse its relationships,
    # returning a hash that maps the relationships among the objects
    # and its child nodes. Call the given block with any relationship found.
    class Traverse
      RELATIONSHIPS = %i[actor inReplyTo object target tag].freeze

      def call(obj, &blk)
        queue = RELATIONSHIPS.map { |rel| obj.public_send(rel) if obj.respond_to?(rel) }.compact

        tree = { obj => nil }

        while !queue.empty? && loop_count <= 20
          RELATIONSHIPS.each do |rel|
            child = obj.respond_to?(rel) ? obj.public_send(rel) : nil
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

            relationship = { obj => { rel => child } }
            blk.call(relationship) if blk
          end

          obj = queue.pop
          @loop_count += 1
        end

        tree
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
