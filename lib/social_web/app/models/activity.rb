# frozen_string_literal: true

module SocialWeb
  class Activity < Sequel::Model(SocialWeb.db[:social_web_activities])
    one_through_one :object,
      join_table: :social_web_object_versions,
      left_key: :social_web_activity_id,
      right_key: :social_web_object_id

    def self.process(json, collection:)
      act = ::ActivityStreams.from_json(json)

      SocialWeb.db.transaction do
        ObjectVersion.create(
          activity: Activity.create(
            collection: collection,
            _id: act.id,
            json: act._original_json,
            type: act.type
          ),
          object: Object.create(
            _id: act.object.id,
            type: act.object.type
          )
        )
      end
    end

    def to_h
      JSON.load(json)
    end

    def object=(obj)
      return if obj.nil?

      self.save
      ObjectVersion.create(
        activity: self,
        object: obj
      )
    end
  end
end
