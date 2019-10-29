# frozen_string_literal: true

module SocialWeb
  class Followers < Collection
    COLLECTION = 'followers'

    def add(actor)
      return if SocialWeb['actors'].exists?(actor)

      SocialWeb['actors'].store(actor, @actor, COLLECTION)
    end
  end
end
