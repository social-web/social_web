# frozen_string_literal: true

require 'roda'
require 'slim'
require 'tilt'

module SocialWeb
  module Rack
    class Routes < Roda
      plugin :halt
      plugin :json
      plugin :middleware
      plugin :render,
        engine: 'html.slim',
        views: File.join(__dir__, 'views')
      plugin :type_routing,
        types: { activity_json: 'application/activity+json' }

      require 'social_web/rack/routes/well_known'

      route do |r|
        actor_iri = parse_actor_iri(r.url)

        r.on('.well-known') { r.run Routes::WellKnown }

        activity_json = r.body.read
        collection = parse_collection(r.url)

        r.on(/.*\/(?:inbox|outbox)$/) do
          r.post do
            SocialWeb.process(activity_json, actor_iri, collection)
            response.status = 201
            ''
          end

          r.get do
            view 'collection',
              locals: {
                collection: collection,
                items: load_collection(actor_iri, collection)
            }
          end
        end

        r.on do
          r.activity_json do
            actor = load_actor(actor_iri)
            actor ? actor.to_json : r.halt(404)
          end
        end
      end

      def load_actor(actor_iri)
        SocialWeb.container['repositories.actors'].find_by(iri: actor_iri)
      end

      def load_collection(actor_iri, collection)
        SocialWeb.
          container['repositories.activities'].
          for_actor_iri(actor_iri, collection: collection).
          items
      end

      def parse_actor_iri(url)
        url.gsub(/\/(?:inbox|outbox)$/, '')
      end

      def parse_collection(url)
        url.split('/')[-1]
      end
    end
  end
end
