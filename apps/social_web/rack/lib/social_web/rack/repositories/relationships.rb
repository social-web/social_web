# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Relationships
        def get(parent:, child:, prop:)
          SocialWeb::Rack.db[:social_web_relationships].first(
            type: prop.to_s,
            parent_iri: parent.id,
            child_iri: child.id,
          )
        end

        def store(parent:, child:, prop:)
          return if stored?(parent: parent, child: child, prop: prop)

          SocialWeb::Rack.db[:social_web_relationships].insert(
            type: prop.to_s,
            parent_iri: parent.id,
            child_iri: child.id,
            created_at: Time.now.utc
          )
        end

        def stored?(parent:, child:, prop:)
          !get(parent: parent, child: child, prop: prop).nil?
        end
      end
    end
  end
end
