# frozen_string_literal: true

require 'implementation_spec_helper'

RSpec.describe 'inbox', type: :request do
  it 'accepts Create activities' do
    act = build :activity, type: 'Create'
    post '/inbox', act.json
    get '/inbox'
    expect(last_response.body).to include(act.json)
  end
end
