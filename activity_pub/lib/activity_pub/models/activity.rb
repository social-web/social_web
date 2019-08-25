# frozen_string_literal: true

module ActivityPub
  class Activity < ::Sequel::Model(DB[:activity_pub_activities])
    one_to_one :object, key: :id, primary_key: :activity_pub_object_id

    def self.process(act, collection:)
      obj = ActivityPub::Object.create(
        uri: act.object.id,
        json: act.object.to_json,
        created_at: Time.now
      )

      ActivityPub::Activity.create(
        collection: collection,
        json: act.original_json,
        created_at: Time.now,
        uri: act.id,
        activity_pub_object_id: obj.id
      )
    end
  end
end
