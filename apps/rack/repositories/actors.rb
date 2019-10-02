# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Actors
        def find_by(iri:)
          found = SocialWeb::Rack.db[:social_web_actors].first(iri: iri)
          ActivityStreams.person(id: found[:iri])
        end

        def store(act, actor, collection)
          SocialWeb::Rack.db[:social_web_actor_actors].insert(
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
