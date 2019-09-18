# frozen_string_literal: true

require 'sequel'

module SocialWeb
  class SpecContainer
    DB = Sequel.connect('postgresql://localhost/social_web_test')

    class Following
      def self.for_actor(actor)
        self.new(actor)
      end

      def initialize(actor)
        @actor = actor
      end

      def add(actor)
        DB[:social_web_actor_actors].insert(
          collection: 'following',
          actor_iri: actor.id,
          for_actor_iri: @actor.id,
          created_at: Time.now.utc
        )
      end

      def includes?(actor)
        found = DB[:social_web_actor_actors].first(
          actor_iri: actor.id,
          for_actor_iri: @actor.id
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

    extend Dry::Container::Mixin

    register(:http_client)

    register(:storage)

    namespace(:collections) do
      register(:following) { Following }
    end

    namespace(:repositories) do
      register(:activities) { ActivitiesRepo.new }
      register(:actors) { ActorsRepo.new }
    end

    namespace(:services) do
      register(:delivery) { ->(_act) {} }
      register(:dereference) { Dereference }
    end
  end
end
