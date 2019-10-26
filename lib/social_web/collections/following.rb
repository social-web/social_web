# frozen_string_literal: true

module SocialWeb
  class Following < Collection
    COLLECTION = 'following'

    def add(actor)
      return if SocialWeb['repositories.actors'].exists?(actor)

      SocialWeb['repositories.actors'].store(actor, @actor, COLLECTION)
    end
  end
end
