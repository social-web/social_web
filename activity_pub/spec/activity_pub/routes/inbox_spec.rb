# frozen_string_literal: true

require 'spec_helper'

module ActivityPub
  class Routes
    RSpec.describe '/inbox', type: :route do
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
            post '/inbox', %({
                "@context": "https://www.w3.org/ns/activitystreams",
                "type": "Create"
              })
            expect(last_response.status).to eq(201)
          end
        end

        it 'runs hooks before and after the request' do
          expect(Hooks).
            to receive(:run).
            with(
                'inbox.post.before',
                activity: kind_of(ActivityStreams::Object),
                request: kind_of(Rack::Request)
              ).
            ordered

          expect(Hooks).
            to receive(:run).
            with(
                'inbox.post.after',
                activity: kind_of(ActivityStreams::Object),
                request: kind_of(Rack::Request),
                response: kind_of(Roda::RodaResponse)
              ).
              ordered

          post '/inbox', %({
            "@context": "https://www.w3.org/ns/activitystreams",
            "type": "Create"
          })
        end
      end
    end
  end
end
