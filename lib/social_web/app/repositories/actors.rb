# frozen_string_literal: true

module SocialWeb
  class Actors < Sequel::Model(SocialWeb.db[:social_web_actors])
    many_to_many :activities,
      class: 'SocialWeb::Activities',
      join_table: :social_web_actor_activities,
      left_key: :actor_iri,
      left_primary_key: :iri,
      right_key: :activity_iri,
      right_primary_key: :iri

    many_to_many :followers,
      class: 'SocialWeb::Followers',
      join_table: :social_web_actor_actors,
      left_key: :actor_iri,
      left_primary_key: :iri,
      right_key: :for_actor_iri,
      right_primary_key: :iri

    def self.by_iri(iri)
      dataset.first!(iri: iri)
    end

    def self.persist(actor)
      find_or_create(iri: actor.id) { |atr| atr.created_at = Time.now.utc }
    end

    def activity=(act, collection:)
      SocialWeb.db[:social_web_actor_activities].insert(
        actor_iri: iri,
        activity_iri: act.iri,
        collection: collection
      )
    end
  end
end
