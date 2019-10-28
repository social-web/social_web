# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Actors
        def find_by(iri:)

          found = SocialWeb::Rack.db[:social_web_actors].first(iri: iri)
          return unless found

          ActivityStreams.from_json(found[:json])
        end

        def store(actor)
          SocialWeb::Rack.db.transaction do
            SocialWeb::Rack.db[:social_web_actors].insert(
              iri: actor.id,
              json: actor.to_json,
              created_at: Time.now.utc
            )
            SocialWeb.container['keys'].generate_for_actor_iri(actor.id)
          end
          true
        rescue StandardError
          false
        end
      end
    end
  end
end
