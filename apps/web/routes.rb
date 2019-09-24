# frozen_string_literal: true

require 'roda'
require 'slim'
require 'tilt'

require 'social_web'

module SocialWeb
  module Web
    class Routes < Roda
      plugin :middleware
      plugin :render,
        engine: 'html.slim',
        views: File.join(__dir__, 'views')
      plugin :type_routing,
        types: { activity_json: 'application/activity+json' }

      require_relative './routes/well_known'

      route do |r|
        r.on('.well-known') { r.run Routes::WellKnown }

        actor = load_actor(r.url)
        collection = load_collection(r.url)

        r.post do
          activity = load_activity(r.body.read)
          SocialWeb.process(activity, actor, collection)
          response.status = 201
          ''
        end

        r.get do
          items = Repositories::Activities.for_actor(actor).for_collection(collection).to_a
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
        ActivityStreams.from_json(json)
      end

      def load_actor(url)
        iri = url.split('/')[0...-1].join('/')
        SocialWeb.container['repositories.actors'].find_by(iri: iri)
      end

      def load_collection(url)
        url.split('/')[-1]
      end
    end
  end
end
