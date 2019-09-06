# frozen_string_literal: true

module SocialWeb
  class ActorActivity < Sequel::Model(SocialWeb.db[:social_web_actor_activities])
    many_to_one :social_web_activities,
      primary_key: :iri,
      key: :activity_iri
  end
end
