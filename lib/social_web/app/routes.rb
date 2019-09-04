# frozen_string_literal: true

require 'roda'
require 'slim'
require 'tilt'

module SocialWeb
  class Routes < Roda
    plugin :halt
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
      r.verify_signature if r.post?
      r.authenticate!

      if r.post?
        @activity = begin
          ActivityStreams.from_json(r.body.read)
        rescue ActivityStreams::Error
          r.halt 400
        end
      end
      @actor = begin
        iri = r.url.split('/')[0...-1].join('/')
        Actors.find_or_create(iri: iri) do |actor|
          actor.created_at = Time.now.utc
        end
      end

      r.hash_routes
    end
  end
end
