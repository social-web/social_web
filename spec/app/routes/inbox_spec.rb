# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  class Routes
    RSpec.describe '/inbox', type: :request do
      describe 'GET /inbox' do
        it 'returns inbox activities' do
          act = create :activity, collection: 'inbox'
          get '/inbox'
          expect(last_response.body).to include(act.json)
        end
      end

      describe 'POST /inbox' do
        it 'returns a 201' do
          allow(Activity).to receive(:process)
          post '/inbox'

          expect(last_response.status).to eq(201)
        end
      end
    end
  end
end
