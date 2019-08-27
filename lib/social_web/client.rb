# frozen_string_literal: true

module SocialWeb
  class Client
    def self.follow(actor, object)
      act = ActivityStreams::Activity::Follow.new(actor: actor, object: object)
      request = ::HTTP.build_request(
        :post,
        act.object.id,
        act.to_json,
        headers: {
          'content-type': 'application/json',
          'date': Time.now.utc.httpdate
        }
      )
      request.headers.add(
        'signature',
        Signature.call(request, SocialWeb.config.private_key)
      )

      client = ::HTTP::Client.new
      client.perform(request, client.default_options)
    end

    HTTP_SIGNATURE_FORMAT = 'headers="%<headers>s",'\
      'keyId="%<keyId>s",' \
      'signature="%<signature>s"'

    Signature = ->(req, key) {
      signing_headers = {
        '(request-target)' => "#{req.verb.downcase} #{req.uri.path}"
      }.merge(req.headers).transform_keys(&:downcase)
      signing_string = signing_headers.
        map { |field, value| "#{field}: #{value}" }.
        join("\n")

      keypair = OpenSSL::PKey::RSA.new(key)
      signature = keypair.sign(OpenSSL::Digest::SHA256.new, signing_string)

      format(
        'headers="%<headers>s",keyId="%<keyId>s",signature="%<signature>s"',
        headers: signing_headers.keys.join(' '),
        keyId: ACTOR.dig(:publicKey, :id),
        signature: Base64.strict_encode64(signature)
      )
    }
  end
end
