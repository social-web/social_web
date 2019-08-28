# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  class Routes
    RSpec.describe '/inbox', type: :request do
      describe 'POST /inbox' do
        it 'returns a 201' do
          allow(Activity).to receive(:process)
          post '/inbox', build(:stream).to_json

          expect(last_response.status).to eq(201)
        end
      end
    end
  end
end
