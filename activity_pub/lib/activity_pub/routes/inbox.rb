# frozen_string_literal: true

module ActivityPub
  class Routes
    %w(inbox.post.before inbox.post.after).each { |hook| Hooks.register(hook) }

    hash_branch('inbox') do |r|
      r.post do
        body = r.body.read
        begin
          activity = ActivityStreams.from_json(body).freeze
        rescue ActivityStreams::Error
          r.halt 400
        end
        req = Rack::Request.new(r.env)
        Hooks.run(
          'inbox.post.before',
          activity: activity,
          request: req
        )

        response.status = 201
        Hooks.run(
          'inbox.post.after',
          activity: activity,
          response: response,
          request: req
        )
        response.write(nil)
      end
    end
  end
end
