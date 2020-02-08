# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Routes, type: :request do
    describe 'GET' do
      it 'returns the JSON representation of the found object' do
        obj = create :object
        header('accept', 'application/activity+json')
        get obj[:id]
        expect(last_response.body).to eq(obj.to_json)
      end

      it 'returns an empty 404 response if the object does not exist' do
        header('accept', 'application/activity+json')
        get '/some-object'
        expect(last_response.status).to eq(404)
        expect(last_response.body).to be_empty
      end
    end

    context 'POST' do
      %w[inbox outbox].each do |collection|
        describe collection do
          it "adds the item to the actor's #{collection}" do
            actor = create :object
            activity = build :object

            expect(SocialWeb).
              to receive(:process).
              with(activity.to_json, actor[:id], collection)

            header('accept', 'application/activity+json')
            post "#{actor[:id]}/#{collection}", activity.to_json
          end
        end
      end
    end
  end
end
