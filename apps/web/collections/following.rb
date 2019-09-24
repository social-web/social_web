# frozen_string_literal: true

module SocialWeb
  module Web
    module Collections
      class Following
        def add(actor, for_actor)
          SocialWeb::Web.db[:social_web_actor_actors].insert(
            collection: 'following',
            actor_iri: actor.id,
            for_actor_iri: for_actor.id,
            created_at: Time.now.utc
          )
        end

        def includes?(actor, for_actor)
          found = SocialWeb::Web.db[:social_web_actor_actors].first(
            actor_iri: actor.id,
            for_actor_iri: for_actor.id
          )

          !found.nil?
        end
      end
    end
  end
end
