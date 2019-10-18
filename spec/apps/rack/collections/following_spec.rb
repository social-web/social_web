# frozen_string_literal: true

require 'rack_spec_helper'

module SocialWeb
  module Rack
    module Collections
      RSpec.describe Following do
        describe '.for_actor' do
          it 'initializes a collection for the given actor' do
            actor = create_actor
            collection = described_class.for_actor(actor)
            expect(collection.for_actor).to eq(actor)
          end
        end
      end
    end
  end
end
