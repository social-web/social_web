# frozen_string_literal: true

module SocialWeb
  module Repositories
    class Keys
      # @param obj [ActivityStreams] the object to the keys for
      # @return [Hash]
      def get_keys_for(obj)
        keys = SocialWeb[:db][:social_web_keys].first(object_iri: obj[:id])
        timestamp = keys[:updated_at].iso8601
        {
          key_id: "#{obj[:id]}/#key-#{timestamp}",
          private: keys[:private],
          public: keys[:public]
        }
      end

      # @param obj [ActivityStreams] the object to the keys for
      # @return [Hash]
      def generate_for_actor(obj)
        keypair = OpenSSL::PKey::RSA.new(2048)
        SocialWeb[:db][:social_web_keys].insert(
          object_iri: obj[:id],
          private: keypair.to_pem,
          public: keypair.public_key.to_pem,
          created_at: Time.now.utc,
          updated_at: Time.now.utc
        )
      end
    end
  end
end
