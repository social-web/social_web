# frozen_string_literal: true

require 'spec_helper'

module Webmention
  class Route
    RSpec.describe '/webmentions', type: :route do
      context 'POST /webmentions' do
        context 'source or target is missing' do
          it 'returns a 400 status' do
            post '/webmentions',
              { source: 'https://example.com/1', target: '' }
            expect(last_response.status).to eq(400)

            post '/webmentions',
              { source: '', target: 'https://example.com/1' }
            expect(last_response.status).to eq(400)

            post '/webmentions', { source: '', target: '' }
            expect(last_response.status).to eq(400)
          end
        end

        context 'when the request includes source and target' do
          it 'returns returns a 201 response' do
            post '/webmentions',
              {
                source: 'https://example.com/1',
                target: 'https://example.com/2'
              }
            expect(last_response.status).to eq(201)
          end
        end
      end
    end
  end
end
