# frozen_string_literal: true

require 'spec_helper'

module ActivityPub
  RSpec.describe Routes, type: :route  do
    describe 'GET /:id' do
      it 'retrieves the object via id' do
        note = create :activity

        header 'Accept',
          'application/ld+json; profile="https://www.w3.org/ns/activitystreams"'
        get "/#{note.object.id}"

        expect(last_response.body).to eq(note.object.json)
      end
    end
  end
end
