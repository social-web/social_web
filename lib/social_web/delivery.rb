# frozen_string_literal: true

module SocialWeb
  class Delivery
    DEFAULT_HEADERS = -> {
      {
        'content-type': 'application/activity+json',
        'date': Time.now.utc.httpdate
      }
    }

    def self.call(uri, json)
      headers = DEFAULT_HEADERS.call
      headers.merge!(
        'signature',
        Signature.call(request, SocialWeb.config.private_key)
      )

      HTTP.headers(headers).follow.post(uri, body: json)
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
