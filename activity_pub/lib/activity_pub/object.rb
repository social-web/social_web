# frozen_string_literal: true

require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL'])

module ActivityPub
  class Object < Sequel::Model(DB[:activity_pub_objects])
    def activity_stream
      ActivityStreams.from_json(source)
    end
  end
end

require 'activity_pub/collections/inbox'
