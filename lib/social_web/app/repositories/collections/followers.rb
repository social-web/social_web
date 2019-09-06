# frozen_string_literal: true

module SocialWeb
  class Followers < Actors
    @dataset = Actors.association_join(:followers)

    dataset_module do
      def for_actor(actor)
        where(for_actor_iri: actor.id)
      end

      def follow(actor, for_actor:)
        SocialWeb.db[:social_web_actor_actors].insert(
          collection: 'followers',
          actor_iri: actor.id,
          for_actor_iri: for_actor.id,
          created_at: Time.now.utc
        )
      end
    end
  end
end
