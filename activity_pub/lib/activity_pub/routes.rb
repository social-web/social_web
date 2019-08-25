# frozen_string_literal: true

module ActivityPub
  class Routes < ::Roda
    plugin :halt
    plugin :hash_routes
    plugin :head
    plugin :hooks
    plugin :json
    plugin :middleware, env_var: 'social_web.activity_pub'
    plugin :module_include
    plugin :type_routing, types: {
      activity_streams: 'application/ld+json; ' \
        'profile="https://www.w3.org/ns/activitystreams"'
    }

    before do
      request.halt 403 unless request.verify_signature
    end

    # Helpers
    require 'activity_pub/helpers/requests'

    request_module Helpers::Requests

    response_module do
      def rack_response
        Rack::Response.new(self.dup.finish)
      end
    end

    # Routes
    require 'activity_pub/routes/inbox'
    require 'activity_pub/routes/outbox'

    route do |r|
      r.hash_branches

      r.on Integer do |id|
        r.activity_streams { Object.first(id: id).json }
      end
    end
  end
end
