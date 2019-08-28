# frozen_string_literal: true

module SocialWeb
  class Routes
    hash_branch "inbox" do |r|
      r.get do
        response.status = 200
        inbox = Activity.inbox
        r.activity_json { inbox.to_json }
        r.html { view('inbox', locals: { items: inbox.items }) }
      end

      r.post do
        r.body.rewind
        Activity.receive(r.body.read, collection: 'inbox')
        response.status = 201
        ''
      rescue ::ActivityStreams::Error, Sequel::Error => e
        response.status = 400
        e.message
      end
    end
  end
end
