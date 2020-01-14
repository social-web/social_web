# frozen_string_literal: true

module SocialWeb
  class Inbox < Collection
    COLLECTION = 'inbox'

    def add(activity)
      return if SocialWeb['activities'].exists?(activity)

      SocialWeb['activities'].store(activity, @actor, COLLECTION)
    end

    def remove(activity)

      return unless SocialWeb['activities'].exists?(activity)

      SocialWeb['activities'].delete(activity)
    end
  end
end
