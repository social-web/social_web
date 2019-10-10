# frozen_string_literal: true

module SocialWeb
  module Rack
    class Delivery
      DEFAULT_HEADERS = -> {
        {
          'content-type': 'application/activity+json',
          'date': Time.now.utc.httpdate
        }
      }

      def self.call(uri, json, public_key:, private_key:)
        request = ::HTTP.build_request(
          :post,
          uri.to_s,
          body: json,
          headers: DEFAULT_HEADERS.call
        )

        signature = Signature.call(
          request,
          prv_key: private_key,
          pub_key: public_key
        )
        request.headers.merge!(signature: signature)

        client = ::HTTP::Client.new
        client.perform(request, client.default_options)
      end

      HTTP_SIGNATURE_FORMAT = 'headers="%<headers>s",'\
        'keyId="%<keyId>s",' \
        'signature="%<signature>s"'

      Signature = ->(request, public_key:, private_key:) {
        signing_headers = {
          '(request-target)' => "#{request.verb.downcase} #{request.uri.path}"
        }.merge(request.headers).transform_keys(&:downcase)
        signing_string = signing_headers.
          map { |field, value| "#{field}: #{value}" }.
          join("\n")

        keypair = OpenSSL::PKey::RSA.new(private_key)
        signature = keypair.sign(OpenSSL::Digest::SHA256.new, signing_string)

        format(
          'headers="%<headers>s",keyId="%<keyId>s",signature="%<signature>s"',
          headers: signing_headers.keys.join(' '),
          keyId: public_key,
          signature: Base64.strict_encode64(signature)
        )
      }
    end
  end
end
