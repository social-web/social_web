# frozen_string_literal: true

require 'roda'
require 'slim'
require 'tilt'

module SocialWeb
  class Routes < Roda
    ACCEPT_HEADER = /application\/ld\+json; profile="https:\/\/www.w3.org\/ns\/activitystreams|application\/activity\+json/.freeze

    plugin :json
    plugin :hash_routes
    plugin :middleware
    plugin :module_include
    plugin :render,
      engine: 'html.slim',
      views: File.join(__dir__, 'views')
    plugin :type_routing, types: {
      activity_json: 'application/activity+json'
    }

    require 'social_web/app/routes/helpers/request_helpers'
    request_module Helpers::RequestHelpers

    require 'social_web/app/routes/inbox'
    require 'social_web/app/routes/outbox'
    require 'social_web/app/routes/well_known'

    route do |r|
      @actor = begin
        actor_path = r.path.split('/')[0...-1].join('/')
        iri = "#{r.scheme}://#{r.host}#{actor_path}"
        Actors.find_or_create(iri: iri) do |actor|
          actor.created_at = Time.now.utc
        end
      end

      r.verify_signature if r.post?
      r.authenticate!

      r.hash_routes
    end
  end
end
