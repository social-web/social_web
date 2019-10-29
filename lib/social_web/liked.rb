# frozen_string_literal: true

module SocialWeb
  class Liked < Collection
    COLLECTION = 'liked'

    def add(object)
      return if SocialWeb['objects'].exists?(object)

      SocialWeb['objects'].store(object, @actor, COLLECTION)
    end
  end
end
