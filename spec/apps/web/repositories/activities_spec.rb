# frozen_string_literal: true

require 'web_spec_helper'

module SocialWeb
  module Web
    module Repositories
      RSpec.describe Activities do
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
          it 'returns actors' do
            actor = create_actor
            activity = create_activity(for_actor: actor)

            collection = described_class.new.for_actor_iri(actor.id)
            expect(collection).to be_a(ActivityStreams::Collection)
            expect(collection.items).to eq([activity])
          end
        end
      end
    end
  end
end
