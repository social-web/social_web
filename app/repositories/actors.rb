# frozen_string_literal: true

module SocialWeb
  module App
    module Repositories
      class Actors
        def store(act, actor, collection)
          DB[:social_web_actor_actors].insert(
            collection: collection,
            actor_iri: act.actor.id,
            for_actor_iri: actor.id,
            created_at: Time.now.utc
          )
        end
      end
    end
  end
end
