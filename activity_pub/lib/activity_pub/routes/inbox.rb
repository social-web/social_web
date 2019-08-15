# frozen_string_literal: true

module ActivityPub
  class Routes
    hash_branch('inbox') do |r|
      r.with_hook('activity_pub.inbox') do
        r.post do
          body = r.body.read

          begin
            JSON.parse(body)
          rescue JSON::ParserError
            r.halt 400
          end

          response.status = 201
          response.write(nil)
        end
      end
    end
  end
end
