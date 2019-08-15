# frozen_string_literal: true

require 'activity_pub'
require 'activity_streams'

# Mount the ActivityPub app
SocialWeb::Routes.use ::ActivityPub::Routes

# Delegate SocialWeb hooks to relevant ActivityPub hooks
ActivityPub.add_hook('activity_pub.inbox.post.after') do |res, req|
  req.body.rewind
  body = req.body.read
  activity = ::ActivityStreams.from_json(body)

  SocialWeb::Hooks.run('activity_pub.inbox.post.after', activity, res, req)
end
