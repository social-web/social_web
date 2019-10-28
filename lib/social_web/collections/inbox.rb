# frozen_string_literal: true

module SocialWeb
  class Inbox < Collection
    COLLECTION = 'inbox'

    def add(activity)
      return if SocialWeb['activities'].exists?(activity)

      SocialWeb['activities'].store(activity, for_actor: @actor, in_collection: COLLECTION)
    end

    def receive(activity)
      case activity.type
      when 'Create' then add(activity)
      when ''
      end
    end
  end
end
