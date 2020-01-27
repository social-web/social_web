# frozen_string_literal: true

module SocialWeb
  module Rack
    module Relations
      class Relationships < Sequel::Model(SocialWeb::Rack.db[:social_web_relationships])
        class << self
          def by_child_iri(iri)
            where(child_iri: iri)
          end

          def by_parent_iri(iri)
            where(parent_iri: iri)
          end

          def by_type(type)
            where(type: type)
          end
        end
      end
    end
  end
end
