# frozen_string_literal: true

module SocialWeb
  module Services
    class Create < ActivityStreams::Activity::Create
      def self.deliver(create, for_actor)
        Activities.persist(
          create,
          actor: for_actor,
          collection: 'outbox'
        )
      end

      def self.receive(create, for_actor:)
        Activities.persist(
          create,
          actor: for_actor,
          collection: 'inbox'
        )
      end
    end
  end
end
