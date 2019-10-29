# frozen_string_literal: true

module SocialWeb
  module Rack
    # Dereference IRIs into ActivityStreams objects
    class Dereference
      def call(iri)
        json = HTTP.headers(accept: 'application/activity+json').get(iri)
        ActivityStreams.from_json(json)
      end
    end
  end
end
