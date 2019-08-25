# frozen_string_literal: true

module ActivityPub
  class Object < Sequel::Model(DB[:activity_pub_objects])
    def self.path(id)
      "/#{id}"
    end

    def activity_stream
      ActivityStreams.from_json(source)
    end
  end
end
