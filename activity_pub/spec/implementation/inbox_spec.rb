# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'inbox', type: :route do
  context 'accept' do
    it 'accepts Create activities' do
      act = build_activity
      post '/inbox', act.to_json
      expect(last_response.status).to eq(201)

      get last_response.headers['Location']
      expect(last_response.body).to eq(act[:object].to_json)
    end
  end
end
