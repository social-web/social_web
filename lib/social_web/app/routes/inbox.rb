# frozen_string_literal: true

module SocialWeb
  class Routes
    hash_branch "inbox" do |r|
      r.get do
        response.status = 200
        Activity.where(collection: 'inbox').map(&:to_h)
      end

      r.post do
        r.body.rewind
        Activity.process(r.body.read, collection: 'inbox')
        response.status = 201
        ''
      rescue ::ActivityStreams::Error, Sequel::Error => e
        response.status = 400
        e.message
      end
    end
  end
end
