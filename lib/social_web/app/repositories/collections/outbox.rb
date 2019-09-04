# frozen_string_literal: true

module SocialWeb
  class Outbox < Activities
    @dataset = SocialWeb.db[:social_web_activities].where(collection: 'outbox')
  end
end
