# frozen_string_literal: true

module SocialWeb
  class Activity < Sequel::Model(SocialWeb.db[:social_web_activities])
    one_through_one :object,
      join_table: :social_web_object_versions,
      left_key: :social_web_activity_id,
      right_key: :social_web_object_id

    def self.receive(act, collection:)
      Activity.create(
        collection: collection,
        _id: act.id,
        json: act._original_json,
        type: act.type
      )
    end

    def after_create
      create_version

      case collection
      when 'outbox' then deliver
      when 'inbox' then receive
      end
      super
    end

    def deliver
      klass = "::SocialWeb::Activities::#{type}".constantize
      klass.deliver(stream)
    end

    def receive
      klass = "::SocialWeb::Activities::#{type}".constantize
      klass.receive(stream)
    end

    def object=(obj)
      return if obj.nil?

      save
      ObjectVersion.create(
        activity: self,
        object: obj
      )
    end

    def to_h
      JSON.load(json)
    end

    def stream
      @stream ||= ActivityStreams.from_json(json)
    end

    private

    def create_version
      SocialWeb.db.transaction do
        ObjectVersion.create(
          activity: self,
          object: Object.find_or_create(
            _id: stream.object.id,
            type: stream.object.type
          )
        )
      end
    end
  end
end
