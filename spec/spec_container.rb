# frozen_string_literal: true

require 'sequel'

module SocialWeb
  class SpecContainer < SocialWeb::Container
    extend Dry::Container::Mixin

    DB = Sequel.connect('postgresql://localhost/social_web_test')

    class Following
      def add(actor, for_actor)
        DB[:social_web_actor_actors].insert(
          collection: 'following',
          actor_iri: actor.id,
          for_actor_iri: for_actor.id,
          created_at: Time.now.utc
        )
      end

      def includes?(actor, for_actor)
        found = DB[:social_web_actor_actors].first(
          actor_iri: actor.id,
          for_actor_iri: for_actor.id
        )

        !found.nil?
      end
    end

    class ActorsRepo
      def store(act, actor, collection)
        DB[:social_web_actor_actors].insert(
          collection: collection,
          actor_iri: act.actor.id,
          for_actor_iri: actor.id
        )
      end
    end

    class ActivitiesRepo
      def exists?(act)
        !DB[:social_web_activities].first(iri: act.id).nil?
      end

      def store(act)
        now = Time.now.utc

        DB[:social_web_activities].insert(
          iri: act.id,
          type: act.type,
          json: act.to_json,
          created_at: now
        )

        DB[:social_web_actors].insert(
          iri: act.actor.id,
          json: act.to_json,
          created_at: now
        )

        DB[:social_web_actor_activities].insert(
          collection: act.collection,
          actor_iri: act.actor.id,
          activity_iri: act.id,
          created_at: now
        )
      end
    end

    namespace(:collections) do
      register(:following) { Following.new }

      namespace(:inbox) do
        register(:accept) { Inbox::Accept.new }
      end

      namespace(:outbox) do
        register(:follow) { Outbox::Follow.new }
      end
    end

    namespace(:repositories) do
      register(:activities) { ActivitiesRepo.new }
      register(:actors) { ActorsRepo.new }
    end

    namespace(:services) do
      register(:delivery) { ->(_) {} }
    end
  end
end
