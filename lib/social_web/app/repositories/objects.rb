# frozen_string_literal: true

module SocialWeb
  class Objects < Sequel::Model(SocialWeb.db[:social_web_objects])
    def self.persist(obj)
      insert(iri: obj.id, type: obj.type, created_at: Time.now.utc)
    end

    def self.by_iri(iri)
      record = first(iri: iri)
      ActivityStreams.from_json(record.json) if record
    end
  end
end

require 'social_web/app/repositories/collections/inbox'

