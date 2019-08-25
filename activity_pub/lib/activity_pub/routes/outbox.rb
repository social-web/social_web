# frozen_string_literal: true

module ActivityPub
  class Routes
    %w(
      outbox.get.before
      outbox.get.after
      outbox.post.before
      outbox.post.after
    ).each { |hook| Hooks.register(hook) }

    hash_branch('outbox') do |r|
      r.get do
        objects = Hooks.run('outbox.get.before', request: r.rack_request)
        activities = objects.to_a.each do |obj|
          case obj
          when String, Hash
          when ActivityStreams::Object then obj.to_h
          end
        end

        response.status = 200

        Hooks.run(
          'outbox.get.after',
          response: response.rack_response,
          request: r.rack_request
        )
        activities
      end

      r.post do
        Hooks.run(
          'outbox.post.before',
          activity: r.activity,
          request: r.rack_request
        )

        response.status = 201

        Hooks.run(
          'outbox.post.after',
          activity: r.activity,
          response: response.rack_response,
          request: r.rack_request
        )
        response.write(nil)
      end
    end
  end
end
