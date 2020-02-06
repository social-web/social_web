# frozen_string_literal: true

module SocialWeb
  module Relations
    class Collections < Sequel::Model(SocialWeb[:db][:social_web_collections])
      class << self
        def by_object_iri(iri)
          where(object_iri: iri)
        end

        def by_actor_iri(iri)
          where(actor_iri: iri)
        end

        def by_type(type)
          where(type: type)
        end
      end
    end
  end
end
