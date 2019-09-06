# frozen_string_literal: true

Sequel.extension :inflector

module SocialWeb
  class Actor
    extend Forwardable

    def_delegators :@actor, :to_json

    def initialize(actor)
      @actor = actor
    end

    def database_id
      Activities.first(iri: @actor.id)
    end

    def id
      @actor.id
    end

    # Delegate most methods to wrapped ActivityStreams model
    def method_missing(m, *args, **kwargs)
      @actor.public_send(m, *args)
    end
  end
end
