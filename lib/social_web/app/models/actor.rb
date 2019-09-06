# frozen_string_literal: true

Sequel.extension :inflector

module SocialWeb
  class Actor
    extend Forwardable

    def_delegators :@actor, :to_json

    def initialize(json)
      @actor = ActivityStreams.from_json(json)
    end

    def database_id
      Activities.first(iri: @actor.id)
    end

    def follow(actor)
      Followers.follow(actor, for_actor: self)
    end

    def id
      @actor.id
    end

    def inbox
      items = Activities.
        for_collection('inbox').
        for_actor(self).
        order(Sequel.desc(Sequel[:social_web_activities][:created_at])).
        to_a
      ActivityStreams.ordered_collection(items: items)
    end

    def outbox
      items = Activities.
        for_collection('outbox').
        for_actor(self).
        order(Sequel.desc(Sequel[:social_web_activities][:created_at])).
        to_a
      ActivityStreams.ordered_collection(items: items)
    end

    # Delegate most methods to wrapped ActivityStreams model
    def method_missing(m, *args, **kwargs)
      @actor.public_send(m, *args)
    end
  end
end
