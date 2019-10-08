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
        r.on('.well-known') { r.run Routes::WellKnown }

        actor = load_actor(r.url)

        r.on(/(?:inbox|outbox)$/) do
          r.halt(404) unless actor

          activity_json = r.body.read
          collection = parse_collection(r.url)

          r.post do
            SocialWeb.process(activity_json, actor, collection)
            response.status = 201
            ''
          end

          r.get do
            view 'collection',
              locals: {
                collection: collection,
                items: load_collection(actor, collection)
            }
          end
        end

        r.activity_json { actor.to_json }
      end

      def load_actor(url)
        actor_iri = parse_actor_iri(url)
        SocialWeb.container['repositories.actors'].find_by(iri: actor_iri)
      end

      def load_collection(actor, collection)
        SocialWeb.
          container['repositories.activities'].
          for_actor_iri(actor.id, collection: collection).
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
