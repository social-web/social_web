# frozen_string_literal: true

module SocialWeb
  class Inbox < Collection
    COLLECTION = 'inbox'

    def add(activity)
      return if SocialWeb['activities'].exists?(activity)

      SocialWeb['activities'].store(activity, @actor, COLLECTION)
    end
  end
end
