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

    before do
      request.verify_signature
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

    route { |r| r.hash_branches }
  end
end
