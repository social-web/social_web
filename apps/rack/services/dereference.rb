# frozen_string_literal: true

module SocialWeb
  module Rack
    # Dereference IRIs into ActivityStreams objects
    class Dereference
      include Container['retrieve']

      # Properties that could contain IRIs that need to be dereferenced
      DEREFERENCERABLE_PROPERTIES = %i[to bto cc bcc audience].freeze

      def call(obj)
        case obj
        when ActivityStreams::Model
          obj.properties.each do |prop, v|
            if DEREFERENCERABLE_PROPERTIES.include?(prop)
              obj.public_send("#{prop}=", call(v))
            end
          end
          return obj
        when String
          retrieve.get(obj) if obj.match?(URI.regexp(%w[http https]))
        when Array then obj.each { |o| call(o) }
        else raise TypeError, "Unable to dereference #{obj}. " \
          'Expects an ActivityStreams::Model or IRI.'
        end
      end
    end
  end
end
