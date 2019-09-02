# frozen_string_literal: true

module SocialWeb
  class Routes
    hash_branch "inbox" do |r|
      r.get do
        response.status = 200
        collection = ActivityStreams.collection
        collection.items = Inbox.for_actor(@actor).
          order(Sequel.desc(:created_at)).
          map { |o| ActivityStreams.from_json(o.json) }

        r.activity_json { collection.to_json }
        r.html { view('inbox', locals: { items: collection.items }) }
      end

      r.post do
        Activity.process(r.activity, actor: @actor, collection: 'inbox')
        response.status = 201
        ''
      rescue ::ActivityStreams::Error, Sequel::Error => e
        response.status = 400
        e.message
      end
    end
  end
end
