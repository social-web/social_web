# frozen_string_literal: true

module SocialWeb
  class Activities < Sequel::Model(SocialWeb.db[:social_web_activities])
    one_to_many :social_web_actor_activities,
      class: 'SocialWeb::ActorActivity',
      primary_key: :iri,
      key: :activity_iri

    dataset_module do
      def for_actor(actor)
        association_join(:social_web_actor_activities)
          .where(Sequel[:social_web_actor_activities][:actor_iri] => actor.id)
      end

      def for_collection(collection)
        association_join(:social_web_actor_activities)
          .where(Sequel[:social_web_actor_activities][:collection] => collection)
      end
    end

    def self.dataset
      @dataset.with_row_proc ->(record) {
        ActivityStreams.from_json(record[:json])
      }
    end

    def self.persist(act, actor:, collection:)
      id = insert(
        iri: act.id,
        json: act._original_json,
        type: act.type,
        created_at: Time.now.utc
      )

      SocialWeb.db[:social_web_actor_activities].insert(
        collection: collection,
        activity_iri: act.id,
        actor_iri: actor.id,
        created_at: Time.now.utc
      )
    end

    def self.by_iri(iri)
      first(iri: iri)
    end
  end
end

require 'social_web/app/repositories/collections/inbox'
require 'social_web/app/repositories/collections/outbox'

