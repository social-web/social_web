# frozen_string_literal: true

require 'roda'
require 'slim'
require 'tilt'

module SocialWeb
  module Rack
    class Routes < Roda
      COLLECTION_REGEX = /(?:inbox|outbox)$/.freeze

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

        actor_iri = parse_actor_iri(r.url)

        r.on(/.*#{COLLECTION_REGEX}/) do
          activity_json = r.body.read
          collection = parse_collection(r.url)

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

        r.activity_json do
          actor = load_actor(actor_iri)
          keys = SocialWeb.container['repositories.keys'].for_actor_iri(actor.id)
          actor.publicKey = {
            id: keys[:key_id],
            owner: actor.id,
            publicKeyPem: keys[:public_key]
          }
          actor.to_json
        end
      end

      def load_actor(actor_iri)
        SocialWeb.
          container['repositories.actors'].
          find_by(iri: actor_iri)
      end

      def load_collection(actor_iri, collection)
        SocialWeb.
          container['repositories.activities'].
          for_actor_iri(actor_iri, collection: collection).
          items
      end

      def parse_actor_iri(url)
        url.gsub(/\/#{COLLECTION_REGEX}/, '')
      end

      def parse_collection(url)
        url[COLLECTION_REGEX]
      end
    end
  end
end
