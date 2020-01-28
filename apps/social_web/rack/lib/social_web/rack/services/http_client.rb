# frozen_string_literal: true

module SocialWeb
  module Rack
    class HTTPClient
      ACTIVITY_JSON_MIME_TYPE = 'application/activity+json'

      Signature = ->(request, key_id:, private_key:) {
        signing_headers = request.headers.merge(
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
          keys = SocialWeb.container['keys'].for_actor_iri(@actor.id)

          signature = Signature.call(
            request,
            private_key: keys.fetch(:private),
            key_id: keys[:key_id]
          )
          request.headers.merge!(signature: signature)
        end

        client = ::HTTP::Client.new
        client.perform(request, client.default_options)
      end
    end
  end
end
