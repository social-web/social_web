# frozen_string_literal: true

module SocialWeb
  module Rack
    class Delivery
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

      def call(activity)
        recipients = parse_recipients(activity)

        recipients.each do |recipient|
          request = ::HTTP.build_request(
            :post,
            recipient.inbox,
            body: activity.to_json,
            headers: {
              'content-type': 'application/activity+json',
              'date': Time.now.utc.httpdate
            }
          )

          keys = SocialWeb.container['repositories.keys'].for_actor_iri(activity.actor)

          signature = Signature.call(
            request,
            prv_key: keys[:private_key],
            pub_key: keys[:public_key]
          )
          request.headers.merge!(signature: signature)

          client = ::HTTP::Client.new
          client.perform(request, client.default_options)
        end
      end

      private

      def parse_target(target)
        case target
        when URI.regexp then target
        when Array then parse_target(target)
        end
      end

      def parse_recipients(activity)
        %i[to bto cc bcc audience].map do |target|
          parse_target(activity.public_send(target))
        end
      end
    end
  end
end
