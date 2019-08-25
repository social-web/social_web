# frozen_string_literal: true

require 'spec_helper'

module ActivityPub
  class Routes
    RSpec.describe '/inbox', type: :route do
      context 'GET /inbox' do
        it 'returns an array of activities' do
          create :activity
          create :activity
          get '/inbox'
          response = JSON.parse(last_response.body)
          expect(response).to be_a(Array)
          expect(response.count).to eq(2)
        end
      end

      context 'POST /inbox' do
        context 'when the request has an empty body' do
          it 'returns a 400 response' do
            post '/inbox'
            expect(last_response.status).to eq(400)
          end
        end

        context 'when the body is not valid JSON' do
          it 'returns a 400 response' do
            post '/inbox', 'beepboop'
            expect(last_response.status).to eq(400)
          end
        end

        context 'when body is valid ActivityStream JSON' do
          it 'creates a record and returns a 201 status' do
            post '/inbox', build_activity.to_json
            expect(last_response.status).to eq(201)
          end
        end

        it 'runs hooks before and after the request' do
          # expect(Hooks).
          #   to receive(:run).
          #   with(
          #       'inbox.post.before',
          #       activity: kind_of(ActivityStreams::Object),
          #       request: kind_of(Rack::Request)
          #     ).
          #   ordered
          #
          # expect(Hooks).
          #   to receive(:run).
          #   with(
          #       'inbox.post.after',
          #       activity: kind_of(ActivityStreams::Object),
          #       request: kind_of(Rack::Request),
          #       response: kind_of(Rack::Response)
          #     ).
          #     ordered
          #
          # post '/inbox', %({
          #   "@context": "https://www.w3.org/ns/activitystreams",
          #   "type": "Create"
          # })
        end
      end
    end
  end
end
