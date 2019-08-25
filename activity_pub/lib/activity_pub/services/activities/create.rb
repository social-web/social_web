# frozen_string_literal: true

module ActivityPub
  module Activities
    class Create
      def initialize(activity, collection:)
        @activity = activity
        raise unless @activity.type == 'Create'

        @collection = collection
      end

      def call
        obj = ActivityPub::Object.create(
          json: @activity.object.to_json,
          created_at: Time.now
        )

        ActivityPub::Activity.create(
          collection: @collection,
          json: @activity.original_json,
          created_at: Time.now,
          activity_pub_object_id: obj.id
        )

        obj
      end
    end
  end
end
