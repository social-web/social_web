# frozen_string_literal: true

module ActivityPub
  module Helpers
    module Requests
      def activty
        @activity ||= ActivityStreams.from_json(body)
      end

      def rack_request
        Rack::Request.new(env)
      end

      #   "signature": {
      #     "type": "RsaSignature2017",
      #     "creator": "https://ruby.social/users/shanecav#main-key",
      #     "created": "2019-08-06T13:18:53Z",
      #     "signatureValue": "Y6wqiUgqm/ykzKw/jCtsB5fQciGq9TMILNt57FanVg5N8UfLg4vG7Z9Xg6jIAMb++UzyDCW2oc3k9OzD/w0iCSsbMG3Mi+0OdVXNEK7DarDMWJHLgOTaUMW7C/hY8Z+OlhbSu+VvhRVuFUETgTxCDxnGSydZyFL8PTjNQ52hbEbkDqKyS+SwyQqr4T4niM5c631cwlVfX8cwSPWKdNjEpQGyqSp4nqxfw//Mtz4n6eK4X0FcZVoGA8ZddZXViZB/xw0SZfxj+ctKqz2BHRtn7f3MNMlkIBdhuqbIy46DfTODQFnnbHsuLykR8uXL7d1nf27sEdczxzcWRgnK8dG+aQ=="
      #   }
      def verify_signature
        return if request_method.downcase != 'post'
        return if [nil, ''].include?(each_header.to_h['Signature'])

        # Parse Authorization header to return algorithm, headers,
        # keyid, and signature parameters
        signature_header = headers['Signature'].
          downcase.
          split(',').
          map { |p| p.match(/(?<param>[a-z]+)="(?<value>.*?)"/) }.
          each_with_object({}) do |match_data, hsh|
          hsh[match_data[:param]] = match_data[:value]
        end

        # Construct the signature string for comparison
        request_target = "#{request_method.downcase} #{path}"
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
        #   uri with fragment: https://example.com
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
        public_key = Clients.http.get(signature_header[:keyid]).body

        digest = OpenSSL::Digest::SHA256.new
        public_key = OpenSSL::PKey::RSA.new(
          # TODO: get key from key id
        )
        signature = Base64.decode(signature_header[:signature])
        public_key.verify(digest, signature, signing_string)
      rescue OpenSSL::PKey::PKeyError
        false
      end

      # Public: Run the given request
      def with_hook(name, &match_block)
        request = self

        # Retrieve the hooks set by the user
        around = Hooks[name + '.around']
        before = Hooks[name + '.before']
        after = Hooks[name + '.after']

        before_and_after = -> do
          before.call(request) if before

          # To run the after hook, we need to interpose it between
          # the end of the match block and the :halt that Roda throws to end the
          # response. We then rethrow to continue
          # Roda's procedure.
          if after
            catch(:halt) do
              after.call(response.rack_response, request.rack_request)
              throw :halt
            end
          end

          match_block.call
        end

        # Wrap the whole thing in an 'around' hook; otherwise call what we got
        around ? around.call(request, &before_and_after) : before_and_after.call
      end
    end
  end
end
