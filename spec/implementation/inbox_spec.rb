# frozen_string_literal: true

require 'implementation_spec_helper'

RSpec.describe 'inbox', type: :request do
  it 'accepts Create activities' do
    create :actor, iri: 'http://example.org'
    act = build :stream,
      type: 'Create',
      object: build(:stream, type: 'Note')

    post '/inbox', act.to_json

    header 'accept', 'application/activity+json'
    get '/inbox'
    collection = ActivityStreams.from_json(last_response.body)
    expect(collection.items).to include(act)
  end
end
