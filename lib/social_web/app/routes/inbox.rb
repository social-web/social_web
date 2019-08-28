# frozen_string_literal: true

module SocialWeb
  class Routes
    hash_branch "inbox" do |r|
      r.get do
        response.status = 200
        collection = ActivityStreams::Collection::OrderedCollection.new
        collection.items = Activity.where(collection: 'inbox').map(&:stream)
        r.json { collection }
        r.html { view('inbox', locals: { collection: collection.items }) }
      end

      r.post do
        Activity.receive(r.activity, collection: 'inbox')
        response.status = 201
        ''
      rescue ::ActivityStreams::Error, Sequel::Error => e
        response.status = 400
        e.message
      end
    end
  end
end
