# frozen_string_literal: true

module SocialWeb
  class Routes
    hash_branch "outbox" do |r|
      r.get do
        response.status = 200
        Activity.where(collection: 'outbox').map(&:to_h)
      end

      r.post do
        Activity.receive(r.activity, collection: 'outbox')
        response.status = 201
        ''
      rescue ::ActivityStreams::Error, Sequel::Error => e
        response.status = 400
        e.message
      end
    end
  end
end
