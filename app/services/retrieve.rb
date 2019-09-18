# frozen_string_literal: true

module SocialWeb
  module Services
    class Retrieve
      def call(iri)
        res = HTTP.get(iri)
        ActivityStreams.from_json(res.body.to_s)
      end
    end
  end
end
