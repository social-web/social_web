# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  module Services
    RSpec.describe Accept, type: :request do
      describe '.receive' do
        context 'when follow had been sent' do
          it 'adds actor to following collection' do
            allow(Activity::Dereference).to receive(:call)
            actor = create :actor, iri: 'http://example.org'
            actr = ActivityStreams.from_json(actor.json)
            follow = create :activity,
              type: 'Follow'
            SocialWeb.db[:social_web_actor_activities].insert(
              actor_iri: actor.iri,
              activity_iri: follow.iri,
              collection: 'outbox',
              created_at: Time.now.utc
            )
            accept = build :stream,
              type: 'Accept',
              actor: actr,
              object: build(:stream, type: 'Follow', id: follow.iri)
            expect { post "/inbox", accept.to_json }.
              to change { Followers.for_actor(actr).count }.by(+1)
          end
        end
      end
    end
  end
end
