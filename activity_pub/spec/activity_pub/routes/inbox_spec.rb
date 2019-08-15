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

        context 'when body is valid JSON' do
          it 'creates a record and returns a 201 status' do
            post '/inbox', '{}'
            expect(last_response.status).to eq(201)
          end
        end

        it 'runs hooks before and after the request' do
          around_hook = ->(req, &blk) { blk.call }
          allow(Hooks).
            to receive(:[]).
            with('activity_pub.inbox.around').
            and_return(around_hook)
          expect(around_hook).
            to receive(:call).
            with(kind_of(Rack::Request)).
            ordered.
            and_call_original

          before_hook = double('before_hook')
          allow(Hooks).
            to receive(:[]).
            with('activity_pub.inbox.before').
            and_return(->(req) { before_hook.call(req) })
          expect(before_hook).
            to receive(:call).
            with(kind_of(Rack::Request)).
            ordered

          after_hook = double('after_hook')
          allow(Hooks).
            to receive(:[]).
            with('activity_pub.inbox.after').
            and_return(->(res, req) { after_hook.call(res, req) })
          expect(after_hook).
            to receive(:call).
            with(kind_of(Rack::Response), kind_of(Rack::Request)).
            ordered

          post '/inbox', '{}'
        end
      end
    end
  end
end
