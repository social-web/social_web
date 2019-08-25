# frozen_string_literal: true

module ActivityPub
  module Activities
    class Process
      def initialize(activity)
        @activity = activity
      end

      def call
        case @activity
        when ::ActivityStreams::Activity::Create
          obj = ActivityPub::Activities::Create.new(act, collection: 'inbox').call
          response.headers['Location'] = ActivityPub::Object.path(obj.id)
        end
      end
    end
  end
end
