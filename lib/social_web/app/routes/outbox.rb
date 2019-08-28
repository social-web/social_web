# frozen_string_literal: true

module SocialWeb
  class Routes
    hash_branch "outbox" do |r|
      r.get do
        response.status = 200
        outbox = Activity.outbox
        r.activity_json { outbox.to_json }
        r.html { view('outbox', locals: { items: outbox.items }) }
      end

      r.post do
        r.body.rewind
        Activity.receive(r.body.read, collection: 'outbox')
        response.status = 201
        ''
      rescue ::ActivityStreams::Error, Sequel::Error => e
        response.status = 400
        e.message
      end
    end
  end
end
