# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Activity do
    describe '.process' do
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
        expect { described_class.process(json, collection: 'inbox') }.
          to change { described_class.count }.by(+1)
      end
    end

    describe '#object=' do
      it 'creates the version for the activity and object' do
        act = create :activity, object: nil
        obj = create :object

        expect{ act.object = obj }.to change { ObjectVersion.count }.by(+1)
      end
    end
  end
end
