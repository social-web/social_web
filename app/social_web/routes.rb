# frozen_string_literal: true

module SocialWeb
  module Rack
    def self.new(app, *args, &block)
      SocialWeb::Container.finalize!
      SocialWeb::Routes.new(app, *args, &block)
    end
  end

  class Routes < ::Roda
    COLLECTION_REGEX = begin
      collections = /(#{SocialWeb[:config].collections.join('|')})/i.freeze
    end

    plugin :halt
    plugin :json
    plugin :middleware
    plugin :type_routing, types: { activity_json: 'application/activity+json' }
    plugin :default_headers, 'Content-Type' => 'text/html; charset=utf-8'
    plugin :common_logger, SocialWeb[:config].loggers[0]

    route do |r|
      iri = r.url
      actor_iri = parse_actor_iri(iri)
      collection_type= parse_collection(iri)

      r.activity_json do
        r.get do
          r.on(/.*#{COLLECTION_REGEX}/) do |collection_type|
            actor = SocialWeb['repositories.objects'].get_by_iri(actor_iri)
            collection = SocialWeb['repositories.collections'].
              get_collection_for_actor(actor: actor, collection: collection_type)
            collection.to_json
          end

          found = SocialWeb['repositories.objects'].get_by_iri(iri)
          found.nil? ? r.halt(404) : found.to_json
        end

        r.post do
          activity_json = r.body.read

          SocialWeb.process(activity_json, actor_iri, collection_type)

          response.status = 201
          ''
        end
      end

      r.on(COLLECTION_REGEX) do |collection_type|

        r.get do
          actor_iri = parse_actor_iri(iri)
          actor = SocialWeb['repositories.objects'].get_by_iri(actor_iri)

          collection = SocialWeb['repositories.collections'].
            get_collection_for_actor(actor: actor, collection: collection_type)

          response.headers['Content-Type'] = 'text/plain'

          items_list = collection[:items].map { |item| item[:id] }.join("\n")

          <<~TXT
            INBOX for #{actor_iri}
            #{collection[:items].count}

            #{items_list}
          TXT
        end
      end
    end

    def parse_actor_iri(url)
      match = url.match(/(.*)\/#{COLLECTION_REGEX}/)
      match ? match[1] : url
    end

    def parse_collection(url)
      url[COLLECTION_REGEX]
    end
  end
end
