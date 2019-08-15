# frozen_string_literal: true

module ActivityPub
  module Clients
    module ActivityPub
      def self.get(uri, opts = {})
        Request.new(:get, uri, opts).call
      end

      class Request < Clients::HTTP::Request
        def call
          res = super
          ActivityStreams.from_json(res.body.to_s)
        end
      end
    end
  end
end
