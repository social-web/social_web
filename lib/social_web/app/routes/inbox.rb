# frozen_string_literal: true

module SocialWeb
  class Routes
    hash_branch "inbox" do |r|
      r.get do
        response.status = 200
        collection = ActivityStreams.collection(
          items: Inbox.for_actor(@actor).order(Sequel.desc(:created_at)).to_a
        )
        r.activity_json { collection.to_json }
        r.html { view('inbox', locals: { items: collection.items }) }
      end

      r.post do
        Activities.persist(@activity, actor: @actor, collection: 'inbox')
        Activity.process(@activity, actor: @actor, collection: 'inbox')
        response.status = 201
        ''
      end
    end
  end
end
