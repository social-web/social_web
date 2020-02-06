# frozen_string_literal: true

module SocialWeb
  module Repositories
    class Keys
      def for_actor_iri(actor_iri)
        keys = SocialWeb[:db][:social_web_keys].first(object_iri: actor_iri)
        timestamp = keys[:updated_at].iso8601
        {
          key_id: "#{actor_iri}/#key-#{timestamp}",
          private: keys[:private],
          public: keys[:public]
        }
      end

      def generate_for_actor_iri(actor_iri)
        keypair = OpenSSL::PKey::RSA.new(2048)
        SocialWeb[:db][:social_web_keys].insert(
          object_iri: actor_iri,
          private: keypair.to_pem,
          public: keypair.public_key.to_pem,
          created_at: Time.now.utc,
          updated_at: Time.now.utc
        )
      end
    end
  end
end
