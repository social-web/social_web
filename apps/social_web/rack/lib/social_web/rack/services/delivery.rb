# frozen_string_literal: true

module SocialWeb
  module Rack
    class Delivery
      HTTP_SIGNATURE_FORMAT = 'headers="%<headers>s",'\
        'keyId="%<keyId>s",' \
        'signature="%<signature>s"'

      PUBLIC_INBOX = 'https://www.w3.org/ns/activitystreams#Public'

      Signature = ->(request, key_id:, private_key:) {
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
          keyId: key_id,
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

          keys = SocialWeb.container['keys'].for_actor_iri(activity.actor)

          signature = SocialWeb::Rack::Delivery::Signature.call(
            request,
            private_key: keys.fetch(:private),
            key_id: keys[:key_id]
          )
          request.headers.merge!(signature: signature)

          client = ::HTTP::Client.new
          client.perform(request, client.default_options)
        end
      end

      private

      def parse_recipients(activity)
        recipients = []
        %i[to bto cc bcc audience].each do |target|
          target_recipients = activity.public_send(target)

          Array(target_recipients).each do |recipient|
            next if recipient == PUBLIC_INBOX

            recipients << SocialWeb.container['services.dereference'].call(recipient)
          end
        end

        recipients
      end
    end
  end
end
