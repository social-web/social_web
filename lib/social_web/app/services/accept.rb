# frozen_string_literal: true

module SocialWeb
  module Services
    class Accept
      def self.deliver(accept)
        target_inbox = accept.object.inbox
        Delivery.call(target_inbox, accept.to_json)
      end

      def self.receive(accept, for_actor:)
        return if Activities.
          for_actor(for_actor).
          for_collection('outbox').
          first(type: 'Follow', iri: accept.object.id).
          nil?

        for_actor.follow(accept.actor)
      end
    end
  end
end
