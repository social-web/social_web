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

      @actor = load_actor(r.url)
      @activity = load_activity(r.body.read) if r.post?

      r.hash_routes
    rescue ::ActivityStreams::Error => e
      raise(e) if ENV['RACK_ENV'] == 'test'

      response.status = 400
      e.message
    end

    def load_activity(json)
      act = ActivityStreams.from_json(json)
      Activity::Dereference.call(act)
      act
    end

    def load_actor(url)
      iri = url.split('/')[0...-1].join('/')
      actor = Actors.find_or_create(iri: iri) do |actor|
        actor.created_at = Time.now.utc
        actor.json = {
          id: iri,
          type: 'Person',
          inbox: "#{iri}/inbox",
          outbox: "#{iri}/outbox"
        }.to_json
      end
      SocialWeb::Actor.new(ActivityStreams.from_json(actor.json))
    end
  end
end
