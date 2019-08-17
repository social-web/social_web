# frozen_string_literal: true

require 'activity_pub'
require 'activity_streams'

# Mount the ActivityPub app
SocialWeb::Routes.use ::ActivityPub::Routes

# Delegate SocialWeb hooks to relevant ActivityPub hooks
SocialWeb::Hooks.register('activity_pub.inbox.post.after')

ActivityPub.add_hook('inbox.post.after') do |hook|
  SocialWeb::Hooks.run('activity_pub.inbox.post.after', hook)
end
