# frozen_string_literal: true

require 'roda'
require 'slim'
require 'tilt'

module SocialWeb
  class Routes < Roda
    plugin :halt
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

    require 'social_web/app/routes/well_known'

    route do |r|
      r.on('.well-known') { r.run Routes::WellKnown}
      r.verify_signature if r.post?
      r.authenticate!

      @actor = load_actor(r.url)
      collection = r.url.split('/')[-1]

      r.post do
        activity = load_activity(r.body.read)
        Activity.process(activity, @actor, collection)
        response.status = 201
        ''
      end

      r.get do
        items = Activities.for_actor(@actor).for_collection(collection).to_a
        stream = ActivityStreams.ordered_collection(items: items)

        r.activity_json { stream.to_json }
        r.html { view('collection', locals: { items: stream.items }) }
      end
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
      Actors.first(iri: iri)
    end
  end
end
