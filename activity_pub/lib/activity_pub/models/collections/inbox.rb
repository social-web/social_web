# frozen_string_literal: true

module ActivityPub
  Inbox = Activity.where(collection: 'inbox')
end

# ActivityPub.add_hook('inbox.post.after') do |evt|
#   # TODO: Verify activity signature
#
#   body = evt[:request].body
#   body.rewind
#   id = ActivityPub::Activ.insert(
#     collection: 'inbox',
#     created_at: Time.now,
#     json: body.read
#   )
#
#   evt[:response].headers['Location'] = "https://example.com/#{id}"
# end
#
# ActivityPub.add_hook('inbox.get.before') do |_evt|
#   ActivityPub::Inbox
# end
