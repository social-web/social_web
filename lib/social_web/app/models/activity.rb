# frozen_string_literal: true

Sequel.extension :inflector

module SocialWeb
  class Activity
    def self.deliver(act)
      klass = "::SocialWeb::Services::#{act.type}".constantize
      klass.deliver(act)
    end

    def self.process(act, collection:)
      SocialWeb.db.transaction do
        Activities.persist(act, collection: collection)

        case collection
        when 'inbox' then receive(act)
        when 'outbox' then deliver(act)
        end
      end
    end

    def self.receive(act)
      klass = "::SocialWeb::Services::#{act.type}".constantize
      klass.receive(act)
    end
  end
end
