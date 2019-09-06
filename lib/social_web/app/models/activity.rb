# frozen_string_literal: true

Sequel.extension :inflector

module SocialWeb
  # Provides APIs for managing Activity Streams objects handled by ActivityPub.
  # Also wraps an ActivityStreams model of ActivityPub purposes.
  class Activity
    extend Forwardable

    # Properties that could contain IRIs that need to be dereferenced
    DEREFERENCERABLE_PROPERTIES = %i[object target to cc bcc bto].freeze

    # Dereference IRIs into ActivityStreams objects
    Dereference = ->(obj) {
      case obj
      when ActivityStreams::Model
        obj.properties.each do |prop, v|
          if DEREFERENCERABLE_PROPERTIES.include?(prop)
            obj.public_send("#{prop}=", Dereference.call(v))
          end
        end
        return obj
      when String then Client.get(obj) if obj.match?(URI.regexp(%w[http https]))
      when Array then obj.each { |o| Dereference.call(o) }
      else raise TypeError, "Unable to dereference #{obj}. " \
        'Expects an ActivityStreams::Model or IRI.'
      end
    }

    def self.deliver(act)
      klass = "::SocialWeb::Services::#{act.type}".constantize
      klass.deliver(act)
    end

    def self.process(act, actor, collection)
      case collection
      when 'inbox' then receive(act, for_actor: actor)
      when 'outbox' then deliver(act)
      end
    end

    def self.receive(act, for_actor:)
      klass = "::SocialWeb::Services::#{act.type}".constantize
      klass.receive(act, for_actor: for_actor)
    end

    def_delegators :@act, :to_json

    def initialize(act)
      @act = Dereference.call(act)
    end

    def database_id
      Activities.first(iri: @act.id)
    end

    def id
      @act.id
    end

    # Delegate most methods to wrapped ActivityStreams model
    def method_missing(m, *args, **kwargs)
      @act.public_send(m, *args)
    end
  end
end
