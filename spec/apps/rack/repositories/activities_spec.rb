# frozen_string_literal: true

require 'rack_spec_helper'

module SocialWeb
  module Rack
    module Repositories
      RSpec.describe Activities do
        describe '#delete' do
          it 'removes the activity' do
            activity = create_activity
            expect { described_class.new.delete(activity) }.
              to change { SocialWeb::Rack.db[:social_web_activities].count }.by(-1)
          end
        end

        describe '#exists?' do
          it 'returns true if record is found' do
            activity = create_activity
            expect(described_class.new.exists?(activity)).to eq(true)
          end

          it 'returns false if record not found' do
            activity = double('activity', id: 'nope')
            expect(described_class.new.exists?(activity)).to eq(false)
          end
        end

        describe '#for_actor_iri' do
          it 'returns activiries for actor' do
            actor = create_actor
            activity = create_activity(for_actor: actor)

            collection = described_class.new.for_actor_iri(actor.id)
            expect(collection).to be_a(ActivityStreams::Collection)
            expect(collection.items).to eq([activity])
          end

          describe 'with collection' do
            it 'returns actors filtered by collection' do
              actor = create_actor
              inbox_activity = create_activity(
                for_actor: actor,
                collection: 'inbox'
              )
              outbox_activity = create_activity(
                for_actor: actor,
                collection: 'outbox'
              )

              collection = described_class.new.
                for_actor_iri(actor.id, collection: 'outbox')
              expect(collection).to be_a(ActivityStreams::Collection)
              expect(collection.items).to eq([outbox_activity])
            end
          end
        end

        describe '#store' do
          it 'persists the activity' do
            actor = create_actor
            activity = ActivityStreams.create {
              id 'https://example.org/activities/1'
            }

            expect { described_class.new.store(activity, actor, 'inbox') }.
              to change { SocialWeb::Rack.db[:social_web_activities].count }.
              by(+1)
          end
        end
      end
    end
  end
end
