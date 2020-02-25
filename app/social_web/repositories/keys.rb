# frozen_string_literal: true

module SocialWeb
  module Repositories
    class Keys
      # @param obj [ActivityStreams] the object to the keys for
      # @return [Hash]
      def get_keys_for(obj)
        result = keys.by_object_iri(obj[:id]).first
        return unless result

        timestamp = result[:updated_at].iso8601
        {
          key_id: "#{obj[:id]}/#key-#{timestamp}",
          private: result[:private],
          public: result[:public]
        }
      end

      # @param obj [ActivityStreams] the object to the keys for
      # @return [Hash]
      def generate_for_actor(obj)
        keypair = OpenSSL::PKey::RSA.new(2048)
        keys.insert(
          object_iri: obj[:id],
          private: keypair.to_pem,
          public: keypair.public_key.to_pem,
          created_at: Time.now.utc,
          updated_at: Time.now.utc
        )
      end

      private

      def keys
        SocialWeb['relations.keys']
      end
    end
  end
end
