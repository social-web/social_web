# frozen_string_literal: true

require 'http'

module SocialWeb
  class Client
    DEFAULT_HEADERS = { 'content-type': 'application/activity+json' }.freeze

    def self.get(iri)
      res = HTTP.
        follow.
        headers(DEFAULT_HEADERS).
        get(iri)

      ActivityStreams.from_json(res.body.to_s)
    end
  end
end
