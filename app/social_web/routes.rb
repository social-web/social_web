# frozen_string_literal: true

module SocialWeb
  module Rack
    def self.new(app, *args, &block)
      SocialWeb::Container.finalize!
      SocialWeb::Routes.new(app, *args, &block)
    end
  end

  class Routes < ::Roda
    COLLECTION_REGEX = /(?:inbox|outbox|following|followers|liked|likes|shared)$/.freeze

    plugin :halt
    plugin :json
    plugin :middleware
    plugin :render,
      engine: 'html.slim',
      views: File.join(__dir__, 'views')
    plugin :type_routing,
      types: { activity_json: 'application/activity+json' }
    plugin :default_headers,
      'Content-Type' => 'text/html; charset=utf-8'
    plugin :common_logger, SocialWeb[:config].loggers

    route do |r|
      r.activity_json do
        r.get do
          found = SocialWeb['repositories.objects'].get_by_iri(r.url)
          found.nil? ? r.halt(404) : found.to_json
        end

        r.post do
          activity_json = r.body.read
          actor_iri = parse_actor_iri(r.url)
          collection = parse_collection(r.url)

          SocialWeb.process(activity_json, actor_iri, collection)

          response.status = 201
          ''
        end
      end
    end

    def parse_actor_iri(url)
      url.gsub(/\/#{COLLECTION_REGEX}/, '').gsub(/\/$/, '')
    end

    def parse_collection(url)
      url[COLLECTION_REGEX]
    end
  end
end
