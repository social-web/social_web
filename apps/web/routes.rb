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

        activity_json = r.body.read
        actor_iri = parse_actor_iri(r.url)
        collection = parse_collection(r.url)

        r.post do
          SocialWeb.process(activity_json, actor_iri, collection)
          response.status = 201
          ''
        end
      end

      def parse_actor_iri(url)
        url.split('/')[0...-1].join('/')
      end

      def parse_collection(url)
        url.split('/')[-1]
      end
    end
  end
end
