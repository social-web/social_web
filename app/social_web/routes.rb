# frozen_string_literal: true

module SocialWeb
  module Rack
    def self.new(app, *args, &block)
      SocialWeb::Container.finalize!
      SocialWeb::Routes.new(app, *args, &block)
    end
  end

  class Routes < ::Roda
    ACTIVITY_JSON_MIME_TYPES = [
      'application/ld+json; profile="https://www.w3.org/ns/activitystreams',
      'application/activity+json'
    ].freeze
    COLLECTION_REGEX = /(#{SocialWeb[:config].collections.join('|')})/i.freeze

    plugin :middleware
    plugin :common_logger, SocialWeb[:config].logger
    plugin :header_matchers

    route do |r|
      iri = r.url
      actor_iri = parse_actor_iri(iri)
      collection_type= parse_collection(iri)

      # We need to specify the Rack-parsed header
      r.on [{ header: 'HTTP_ACCEPT' }, { header: 'HTTP_CONTENT_TYPE' }] do |content_type|
        return unless ACTIVITY_JSON_MIME_TYPES.include?(content_type)

        r.get do
          r.on(/.*#{COLLECTION_REGEX}/) do |collection_type|
            actor = SocialWeb['repositories.objects'].get_by_iri(actor_iri)
            collection = SocialWeb['repositories.collections'].
              get_collection_for_actor(actor: actor, collection: collection_type)

            response.headers['content-type'] = ACTIVITY_JSON_MIME_TYPES.join(',')
            collection.to_json
          end

          found = SocialWeb['repositories.objects'].get_by_iri(iri)
          if found.nil?
            response.status = 404
            nil
          else
            found.to_json
          end
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

          response.headers['content-type'] = 'text/plain; charset=utf-8'

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
