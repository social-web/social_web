# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  module Collections
    RSpec.describe Outbox do
      describe '#process' do
        context 'Follow' do
          it "posts the follow to the target's inbox" do
            actor = create :object, type: 'Actor'

            actor_to_follow = create :object, type: 'Actor', inbox: 'inbox'
            follow = create :object, type: 'Follow', object: actor_to_follow

            outbox = described_class.for_actor(actor)

            http_client = instance_double(SocialWeb['services.http_client'])
            expect(SocialWeb['services.http_client']).
              to receive(:for_actor).
              with(actor).
              and_return(http_client)

            expect(http_client).
              to receive(:post).
              with(object: follow, to_collection: actor_to_follow[:inbox])

            outbox.process(follow)
          end
        end
      end
    end
  end
end
