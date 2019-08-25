# frozen_string_literal: true

module ActivityPub
  class Routes
    %w(
      inbox.get.before
      inbox.get.after
      inbox.post.before
      inbox.post.after
    ).each { |hook| Hooks.register(hook) }

    hash_branch('inbox') do |r|
      r.get do
        response.status = 200
        ActivityPub::Inbox.all.map(&:json)
      end

      r.post do
        act = Activity.process(r.activity, collection: 'inbox')

        response.headers['location'] = Object.path(act.object.id)
        response.status = 201
        ''
      rescue ActivityStreams::Error => e
        response.status = 400
        e.message
      end
    end
  end
end
