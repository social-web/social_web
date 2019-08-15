# frozen_string_literal: true

require 'http'

module ActivityPub
  module Clients
    module HTTP
      def self.get(uri, opts = {})
        Request.new(:get, uri, opts).call
      end

      class Request
        def initialize(method, uri, opts = {})
          @method = method
          @uri = URI(uri)
          raise TypeError, 'Expected an HTTP URI' unless @uri.is_a?(HTTP::URI)

          @options = opts
        end

        def call
          ::HTTP.
            headers('Accept': 'application/ld+json; profile="https://www.w3.org/ns/activitystreams"').
            request(@method, @uri, @options)
        end
      end
    end
  end
end
