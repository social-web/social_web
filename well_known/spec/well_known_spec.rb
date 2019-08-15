# frozen_string_literal: true

require 'spec_helper'

module WellKnown
  class Routes
    RSpec.describe '/.well-known', type: :route do
      context '/.well-known/webfinger' do
        context 'GET /.well-known/webfinger' do
          context 'resource is absent or empty' do
            it 'returns a 400' do
              get '/.well-known/webfinger'
              expect(last_response.status).to eq(400)
            end
          end

          context 'resource is not found' do
            it 'returns a 404' do
              get '/.well-known/webfinger', { resource: '' }
              expect(last_response.status).to eq(404)
            end
          end

          context 'resource is found' do
            it 'returns the resource' do
              subject = 'acct:beep@boop.com'
              configure do |config|
                allow(config).
                  to receive(:webfinger_resource).
                  and_return(subject: subject)
              end

              get '/.well-known/webfinger', { resource: subject }
              expect(last_response.status).to eq(200)
              expect(last_response.content_type).to eq('application/jrd+json')
            end
          end

          it 'runs hooks before and after the request' do
            expect(Hooks).
              to receive(:run).
              ordered.
              with(
                'well_known.webfinger.before_get',
                kind_of(Rack::Request)
              )
            expect(Hooks).
              to receive(:run).
              ordered.
              with(
                'well_known.webfinger.after_get',
                kind_of(Roda::RodaResponse)
              )
            get '/.well-known/webfinger', '{}'
          end
        end
      end
    end
  end
end
