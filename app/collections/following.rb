# frozen_string_literal: true

module SocialWeb
  module App
    module Collections
      class Following
        def self.for_actor(actor)
          new(actor)
        end

        def initialize(actor)
          @for_actor = actor
        end

        def add(actor)
          SocialWeb.db[:social_web_actor_actors].insert(
            collection: 'following',
            actor_iri: actor.id,
            for_actor_iri: @actor.id,
            created_at: Time.now.utc
          )
        end

        def includes?(actor)
          found = SocialWeb.db[:social_web_actor_actors].first(
            actor_iri: actor.id,
            for_actor_iri: @actor.id
          )

          !found.nil?
        end
      end
    end
  end
end
