# frozen_string_literal: true

module SocialWeb
  module Repositories
    class Activities
      def self.create(activity)
        actor_iri
        activity_iri
        collection
      end
    end
  end
end
