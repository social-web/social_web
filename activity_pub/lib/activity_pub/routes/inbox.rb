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
        objects = Hooks.run('inbox.get.before', request: r.rack_request)
        activities = if objects.is_a?(Array)
          objects.each do |obj|
            case obj
            when String, Hash
            when ActivityStreams::Object then obj.to_h
            end
          end
        else
          []
        end
        response.status = 200
        Hooks.run(
          'inbox.get.after',
          response: response.rack_response,
          request: r.rack_request
        )
        activities
      end

      r.post do
        Hooks.run(
          'inbox.post.before',
          activity: r.activity,
          request: r.rack_request
        )

        response.status = 201
        Hooks.run(
          'inbox.post.after',
          activity: r.activity,
          response: response.rack_response,
          request: r.rack_request
        )
        response.write(nil)
      end
    end
  end
end
