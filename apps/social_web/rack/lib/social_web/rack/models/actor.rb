# frozen_string_literal: true

module SocialWeb
  module Rack
    module Models
      class Actor
        def initialize(iri)
          @iri = iri
        end

        def inbox
          collection('inbox')
        end

        def outbox
          collection('outbox')
        end

        private

        def collection(type)
          items = SocialWeb['collections'].for_actor_iri(@iri).by_type(type)
          ActivityStreams.collection(
            items: items.map { |i| ActivityStreams.from_json(i[:json]) }
          )
        end
      end
    end
  end
end
