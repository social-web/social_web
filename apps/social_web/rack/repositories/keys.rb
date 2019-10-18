# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Keys
        def for_actor(actor)
          keys = SocialWeb::Rack.db[:social_web_keys].first(actor_iri: actor.id)
          { private: keys.private, public: keys.public }
        end

        def generate_for_actor(actor)
          keypair = OpenSSL::PKey::RSA.new(2048)
          SocialWeb::Rack.db[:social_web_keys].insert(
            actor_iri: actor.id,
            private: keypair.to_pem,
            public: keypair.public_key.to_pem
          )
        end
      end
    end
  end
end
