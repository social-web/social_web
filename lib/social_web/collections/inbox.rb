# frozen_string_literal: true

module SocialWeb
  class Inbox < Collection
    COLLECTION = 'inbox'

    def add(activity)
      return if SocialWeb['repositories.activities'].exists?(activity)

      SocialWeb['repositories.activities'].store(activity, @actor, COLLECTION)
    end
  end
end
