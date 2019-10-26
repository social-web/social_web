# frozen_string_literal: true

module SocialWeb
  class Collection
    def self.for_actor(actor)
      new(actor)
    end

    def initialize(actor)
      @actor = actor
    end
  end
end
