# frozen_string_literal: true

module ActivityStreams
  module Concerns
    module Serialization
      def _unsupported_properties
        @_unsupported_properties ||= {}
      end

      def _unsupported_properties=(v)
        @_unsupported_properties = v
      end

      def to_json(*args)
        JSON.dump(to_h)
      end

      def to_h
        props = properties.dup
        props.merge!( '@context' => _context ) if _context
        props.merge!(_unsupported_properties) unless _unsupported_properties.empty?
        props = self.is_a?(ActivityStreams::Activity::Update) ? props : props.compact
        props.transform_values do |v|
          case v
          when ActivityStreams::Model then v.to_h
          when Date, Time then v.iso8601
          else v
          end
        end
      end
    end
  end
end