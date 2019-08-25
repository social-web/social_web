# frozen_string_literal: true

module ActivityPub
  Outbox = Object.where(collection: 'outbox')
end

ActivityPub.add_hook('outbox.post.after') do |evt|
  # TODO: Verify activity signature

  ActivityPub::Outbox << {
    collection: 'outbox',
    created_at: Time.now,
    json: evt[:request].body.to_s
  }
end

ActivityPub.add_hook('outbox.get.before') do |_evt|
  ActivityPub::Outbox
end
