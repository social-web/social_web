# frozen_string_literal: true

module SocialWeb
  class Actors < Sequel::Model(SocialWeb.db[:social_web_actors])
    def self.by_iri(iri)
      dataset.first!(iri: iri)
    end
  end
end
