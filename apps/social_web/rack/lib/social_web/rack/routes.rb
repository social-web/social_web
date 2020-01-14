# frozen_string_literal: true

require 'roda'
require 'slim'
require 'tilt'

module SocialWeb
  module Rack
    def self.new(app, *args, &block)
      SocialWeb::Rack.start!
      SocialWeb::Rack::Routes.new(app, *args, &block)
    end

    class Routes < Roda
      COLLECTION_REGEX = /(?:inbox|outbox|following|followers|liked|likes|shared)$/.freeze

      plugin :halt
      plugin :json
      plugin :middleware
      plugin :render,
        engine: 'html.slim',
        views: File.join(__dir__, 'views')
      plugin :type_routing,
        types: { activity_json: 'application/activity+json' }

      route do |r|
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
                items: load_collection(actor_iri, collection).items
              }
          end
        end

        r.activity_json do
          actor = load_actor(actor_iri)
          r.halt(404) unless actor

          keys = SocialWeb['keys'].for_actor_iri(actor.id)

          actor.publicKey = {
            id: keys[:key_id],
            owner: actor.id,
            publicKeyPem: keys[:public]
          }
          actor.to_json
        end
      end

      def load_actor(actor_iri)
        SocialWeb['objects_repo'].get_by_iri(actor_iri)
      end

      def load_collection(actor_iri, collection)
        SocialWeb['collections_repo'].get_collection_for_iri(collection: collection, iri: actor_iri)
      end

      def parse_actor_iri(url)
        url.gsub(/\/#{COLLECTION_REGEX}/, '').gsub(/\/$/, '')
      end

      def parse_collection(url)
        url[COLLECTION_REGEX]
      end
    end
  end
end
