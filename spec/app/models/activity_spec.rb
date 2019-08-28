# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Activity do
    describe '.receive' do
      it 'persist an activity and its object' do
        json = %({
          "@context": "https://www.w3.org/ns/activitystreams",
          "id": "http://example.com/2",
          "type": "Create",
          "object": {
            "id": "http://example.com/1",
            "type": "Note"
          }
        })
        expect { described_class.receive(json, collection: 'inbox') }.
          to change { described_class.count }.by(+1)
      end
    end

    describe '.create' do
      it 'creates the object and its version for the activity' do
        expect{ create :activity }.to change { ObjectVersion.count }.by(+1)
      end
    end
  end
end
