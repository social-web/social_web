# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Activities
        def exists?(act)
          found = SocialWeb::Rack.db[:social_web_activities].first(iri: act.id)
          !found.nil?
        end

        def for_actor_iri(actor_iri)
          found = SocialWeb::Rack.
            db[:social_web_activities].
            join(:social_web_actor_activities, activity_iri: :iri).
            where(Sequel[:social_web_actor_activities][:actor_iri] => actor_iri)

          collection = ActivityStreams.collection
          collection.items = found.map { |act| ActivityStreams.from_json(act[:json]) }
          collection
        end

        def store(activity, actor, collection)
          return if exists?(activity)

          SocialWeb::Rack.db.transaction do
            now = Time.now.utc

            SocialWeb::Rack.db[:social_web_activities].insert(
              iri: activity.id,
              type: activity.type,
              json: activity.to_json,
              created_at: now
            )

            SocialWeb::Rack.db[:social_web_actor_activities].insert(
              collection: collection,
              actor_iri: actor.id,
              activity_iri: activity.id,
              created_at: now
            )
          end
        end
      end
    end
  end
end
