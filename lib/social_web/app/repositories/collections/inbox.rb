# frozen_string_literal: true

module SocialWeb
  class Inbox < Activities
    @dataset = SocialWeb.db[:social_web_activities].where(collection: 'inbox')
  end
end
