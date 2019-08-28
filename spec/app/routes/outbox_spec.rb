# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  class Routes
    RSpec.describe '/outbox', type: :request do
      describe 'POST /outbox' do
        it 'returns a 201' do
          allow(Activity).to receive(:receive)
          post '/outbox', build(:stream).to_json

          expect(last_response.status).to eq(201)
        end

        it 'dispatches the action' do
          person = build :stream, type: 'Person'
          act = build :stream,
            type: 'Follow',
            object: person

          allow(ActivityStreams).
            to receive(:from_uri).
            with(person.id).
            and_return(double('Person', inbox: person.id))

          expect(SocialWeb::Delivery).
            to receive(:call).with(person.id, act.to_json)

          post '/outbox', act.to_json
        end
      end
    end
  end
end
