# frozen_string_literal: true

module SocialWeb
  class Outbox < Collection
    COLLECTION = 'outbox'

    def add(activity)
      SocialWeb['repositories.activities'].store(activity, @actor, COLLECTION)
    end
  end
end
