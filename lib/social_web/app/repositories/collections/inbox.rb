# frozen_string_literal: true

module SocialWeb
  class Inbox < Sequel::Model(Activities.where(collection: 'inbox'))
    many_to_many :objects,
      class: 'SocialWeb::Objects',
      join_table: :social_web_object_activities,
      left_key: :social_web_activity_id,
      right_key: :social_web_object_id

    def self.for_actor(actor)
      dataset.where(actor_iri: actor.iri)
    end
  end
end
