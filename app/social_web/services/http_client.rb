# frozen_string_literal: true

module SocialWeb
  module Services
    class HTTPClient
      ACTIVITY_JSON_MIME_TYPE = 'application/activity+json'

      Signature = ->(request, key_id:, private_key:) {
        signing_headers = request.headers.to_h.merge(
          '(request-target)' => "#{request.verb.downcase} #{request.uri.path}"
        ).transform_keys(&:downcase)

        signing_string = signing_headers.
          map { |field, value| "#{field}: #{value}" }.
          join("\n")

        keypair = OpenSSL::PKey::RSA.new(private_key)
        signature = keypair.sign(OpenSSL::Digest::SHA256.new, signing_string)

        format(
          'headers="%<headers>s",keyId="%<keyId>s",signature="%<signature>s"',
          headers: signing_headers.keys.join(' '),
          keyId: key_id,
          signature: Base64.strict_encode64(signature)
        )
      }

      def self.for_actor(actor)
        new(actor)
      end

      def initialize(for_actor = nil)
        @actor = for_actor
      end

      def get(iri)
        request = ::HTTP.build_request(
          :get,
          iri,
          headers: {
            accept: ACTIVITY_JSON_MIME_TYPE,
            date: Time.now.utc.httpdate
          }
        )

        if @actor
          keys = SocialWeb.container['repositories.keys'].get_keys_for(@actor)

          signature = Signature.call(
            request,
            private_key: keys.fetch(:private),
            key_id: keys[:key_id]
          )
          request.headers.merge!(signature: signature)
        end

        client = ::HTTP::Client.new
        res = client.perform(request, client.default_options)
        return unless res.status.success?

        ActivityStreams.from_json(res.body.to_s)
      end

      def post(object:, to_collection:)
        request = ::HTTP.build_request(
          :post,
          to_collection.is_a?(ActivityStreams) ? to_collection[:id] : to_collection,
          headers: {
            accept: ACTIVITY_JSON_MIME_TYPE,
            date: Time.now.utc.httpdate
          },
          body: object.compress.to_json
        )

        if @actor
          keys = SocialWeb.container['repositories.keys'].get_keys_for(@actor)

          signature = Signature.call(
            request,
            private_key: keys.fetch(:private),
            key_id: keys.fetch(:key_id)
          )
          request.headers.merge!(signature: signature)
        end

        client = ::HTTP::Client.new
        res = client.perform(request, client.default_options)

        res.status.success?
      end
    end
  end
end
