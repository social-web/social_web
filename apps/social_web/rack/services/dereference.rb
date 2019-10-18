# frozen_string_literal: true

module SocialWeb
  module Rack
    # Dereference IRIs into ActivityStreams objects
    class Dereference
      def call(iri)
        json = HTTP.get(iri)
        ActivityStreams.from_json(json)
      end
    end
  end
end
