# frozen_string_literal: true

require 'implementation_spec_helper'

RSpec.describe 'outbox', type: :request do
  it 'accepts Create activities' do
    act = build :stream,
      type: 'Create',
      object: build(:stream, type: 'Note')

    post '/outbox', act.to_json

    header 'accept', 'application/activity+json'
    get '/outbox'
    collection = ActivityStreams.from_json(last_response.body)
    expect(collection.items).to include(act)
  end
end
