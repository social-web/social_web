# frozen_string_literal: true

module SocialWeb
  class Likes < Collection
    COLLECTION = 'likes'

    def add(object)
      return if SocialWeb['objects'].exists?(object)

      SocialWeb['objects'].store(object, @actor, COLLECTION)
    end
  end
end
