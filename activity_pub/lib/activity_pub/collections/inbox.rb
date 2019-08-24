# frozen_string_literal: true

module ActivityPub
  Inbox = Object.where(collection: 'inbox')
end

ActivityPub.add_hook('inbox.post.before') do |evt|
  # TODO: Verify activity signature

  ActivityPub::Inbox << {
    collection: 'inbox',
    created_at: Time.now,
    source: evt[:activity].original_json
  }
end

ActivityPub.add_hook('inbox.get.before') do |_evt|
  ActivityPub::Inbox
end
