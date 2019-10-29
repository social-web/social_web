# frozen_string_literal: true

module SocialWeb
  class Activity
    def self.for_actor(actor)
      new(actor)
    end

    def initialize(actor)
      @actor = actor
    end
  end
end
