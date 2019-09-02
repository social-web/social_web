# frozen_string_literal: true

module SocialWeb
  class Routes
    module Helpers
      module RequestHelpers
        # Immediately wrap the incoming activity in our model
        def activity
          @activity ||= Activity.new(ActivityStreams.from_json(body.read))
        rescue ActivityStreams::Error
          halt 400
        end

        def authenticate!
          env['warden']&.authenticate
        end

        def verify_signature
          headers = each_header.to_h
          signature_header = headers.delete('Signature')
          return if !request_method.casecmp?('post')
          return if [nil, ''].include?(signature_header)

          # Parse Authorization header to return algorithm, headers,
          # keyid, and signature parameters
          signature_params = signature_header.
            split(',').
            map { |p| p.match(/(?<key>.+?)="?(?<value>.*?)"?$/) }.
            each_with_object({}) do |param, hsh|
            hsh[param[:key]] = if param[:value].to_i.to_s == param[:value]
              param[:value].to_i
            else
              param[:value]
            end
          end

          # Construct the signature string for comparison
          request_target = "#{request_method.downcase} #{fullpath}"
          signing_headers = { '(request-target)': request_target }.
            merge(headers).
            transform_keys(&:downcase)
          signing_string = signing_headers.
            map { |field, value| "#{field}: #{value}" }.
            join("\n")

          # Possible keyId formats:
          #   webfinger: acct:someone@somewhere.com
          #     legacy OStatus format
          #     - https://github.com/tootsuite/mastodon/issues/4906#issuecomment-328844846
          #   uri: https://example.com
          #   uri with fragment: https://example.com#main-key
          # From: https://github.com/tootsuite/mastodon/issues/4906#issuecomment-328844846
          #   Mastodon will ignore actors without WebFinger (it performs verification for username@domain ownership), and Mastodon
          #   will ignore actors without an inbox.
          #
          #   Mastodon will ignore inbox deliveries that do not have a HTTP signature (unauthenticated). The HTTP signature
          #   keyId may be the actor URL or the public key URL. If it's the public key URL, public key and actor must link
          #   to each other (owner/publicKey).
          #
          #   For legacy, OStatus purposes the keyId can also be [acct:]username@domain, since OStatus used to return magic
          #   key in WebFinger.

          unless URI(signature_params['keyId']).is_a?(URI::HTTP)
            raise TypeError, 'Expects "keyId" to be a URI'
          end
          actor = Clients.
            activity_pub.
            get(signature_params['keyId'])
          public_key = actor.publicKey['publicKeyPem'].strip

          digest = OpenSSL::Digest::SHA256.new
          pkey = OpenSSL::PKey::RSA.new(public_key)
          signature = Base64.decode64(signature_params['signature'])
          pkey.verify(digest, signature, signing_string)
        rescue OpenSSL::PKey::PKeyError
          false
        end
      end
    end
  end
end
