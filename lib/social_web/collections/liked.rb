# frozen_string_literal: true

module SocialWeb
  class Liked < Collection
    COLLECTION = 'liked'

    def add(object)
      return if SocialWeb['repositories.objects'].exists?(object)

      SocialWeb['repositories.objects'].store(object, @actor, COLLECTION)
    end
  end
end
