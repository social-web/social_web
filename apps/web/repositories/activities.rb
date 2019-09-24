# frozen_string_literal: true

module SocialWeb
  module Web
    module Repositories
      class Activities
        def exists?(act)
          found = SocialWeb::Web.db[:social_web_activities].first(iri: act.id)
          !found.nil?
        end

        def store(act)
          now = Time.now.utc

          SocialWeb::Web.db.transaction do
            begin
              SocialWeb::Web.db[:social_web_activities].insert(
                iri: act.id,
                type: act.type,
                json: act.to_json,
                created_at: now
              )
            rescue Sequel::NotNullConstraintViolation, Sequel::UniqueConstraintViolation
            end

            begin
              SocialWeb::Web.db[:social_web_actors].insert(
                iri: act.actor.id,
                json: act.to_json,
                created_at: now
              )
            rescue Sequel::NotNullConstraintViolation, Sequel::UniqueConstraintViolation
            end

            begin
              SocialWeb::Web.db[:social_web_actor_activities].insert(
                collection: act.collection,
                actor_iri: act.actor.id,
                activity_iri: act.id,
                created_at: now
              )
            rescue Sequel::NotNullConstraintViolation, Sequel::UniqueConstraintViolation
            end
          end
        end
      end
    end
  end
end
