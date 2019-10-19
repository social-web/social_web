# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Keys
        def for_actor_iri(actor_iri)
          keys = SocialWeb::Rack.db[:social_web_keys].first(actor_iri: actor_iri)
          { private: keys.private, public: keys.public }
        end

        def generate_for_actor_iri(actor_iri)
          keypair = OpenSSL::PKey::RSA.new(2048)
          SocialWeb::Rack.db[:social_web_keys].insert(
            actor_iri: actor_iri,
            private: keypair.to_pem,
            public: keypair.public_key.to_pem,
            created_at: Time.now.utc,
            updated_at: Time.now.utc
          )
        end
      end
    end
  end
end
