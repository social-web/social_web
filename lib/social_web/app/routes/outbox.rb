# frozen_string_literal: true

module SocialWeb
  class Routes
    hash_branch "outbox" do |r|
      r.get do
        response.status = 200
        outbox = ActivityStreams.
          ordered_collection(items: Outbox.for_actor(@actor).all)

        r.activity_json { outbox.to_json }
        r.html { view('outbox', locals: { items: outbox.items }) }
      end

      r.post do
        Activity.process(@activity, actor: @actor, collection: 'outbox')
        response.status = 201
        ''
      end
    end
  end
end
