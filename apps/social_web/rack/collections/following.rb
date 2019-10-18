# frozen_string_literal: true

module SocialWeb
  module Rack
    module Collections
      class Following
        def self.for_actor(actor)
          new(actor)
        end

        attr_accessor :for_actor

        def initialize(for_actor)
          @for_actor = for_actor
        end

        def add(actor)
          SocialWeb::Rack.db[:social_web_actor_actors].insert(
            collection: 'following',
            actor_iri: actor.id,
            for_actor_iri: for_actor.id,
            created_at: Time.now.utc
          )
        end

        def includes?(actor)
          found = SocialWeb::Rack.db[:social_web_actor_actors].first(
            actor_iri: actor.id,
            for_actor_iri: for_actor.id
          )

          !found.nil?
        end
      end
    end
  end
end
