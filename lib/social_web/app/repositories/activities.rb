# frozen_string_literal: true

module SocialWeb
  class Activities < Sequel::Model(SocialWeb.db[:social_web_activities])
    def self.persist(act, collection:)
      id = insert(
        collection: collection,
        _id: act.id,
        json: act._original_json,
        type: act.type,
        created_at: Time.now.utc
      )

      object_id = Objects[_id: act.object.id]&.id ||
        Objects.persist(act.object)

      SocialWeb.db[:social_web_object_versions].insert(
        social_web_activity_id: id,
        social_web_object_id: object_id,
        created_at: Time.now.utc
      )
    end

    def self.by_iri(iri)
      record = first(_id: iri)
      ActivityStreams.from_json(record.json) if record
    end
  end
end

require 'social_web/app/repositories/collections/inbox'
require 'social_web/app/repositories/collections/outbox'
