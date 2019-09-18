# frozen_string_literal: true

module SocialWeb
  class Activities
    def exists?(act)
      !SocialWeb.db[:social_web_activities].first(iri: act.id).nil?
    end

    def store(act)
      now = Time.now.utc

      SocialWeb.db[:social_web_activities].insert(
        iri: act.id,
        type: act.type,
        json: act.to_json,
        created_at: now
      )

      SocialWeb.db[:social_web_actors].insert(
        iri: act.actor.id,
        json: act.to_json,
        created_at: now
      )

      SocialWeb.db[:social_web_actor_activities].insert(
        collection: act.collection,
        actor_iri: act.actor.id,
        activity_iri: act.id,
        created_at: now
      )
    end
  end
end

require 'social_web/app/repositories/collections/inbox'
require 'social_web/app/repositories/collections/outbox'

