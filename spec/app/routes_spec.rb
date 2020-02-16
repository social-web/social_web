# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Routes, type: :request do
    describe 'GET' do
      before { header('accept', 'application/activity+json') }

      it 'returns the JSON representation of the found object' do
        obj = create :object
        get obj[:id]
        expect(last_response.body).to eq(obj.to_json)
      end

      it 'returns an empty 404 response if the object does not exist' do
        get '/some-object'
        expect(last_response.status).to eq(404)
        expect(last_response.body).to be_empty
      end

      %w[inbox outbox].each do |collection|
        context collection do
          it 'returns the collection and items' do
            actor = create :object, type: 'Actor'
            item = create :object
            col = build :collection,
              for_actor: actor,
              items: [item],
              type: 'OrderedCollection',
              name: collection
            actor[collection.to_sym] = col

            get "#{actor[:id]}/#{collection}"
            expect(last_response.body).to eq(col.to_json)
          end
        end
      end
    end

    context 'POST' do
      before { header('content-type', 'application/activity+json') }

      %w[inbox outbox].each do |collection|
        describe collection do
          it "adds the item to the actor's #{collection}" do
            actor = create :object
            activity = build :object

            expect(SocialWeb).
              to receive(:process).
              with(activity.to_json, actor[:id], collection)

            post "#{actor[:id]}/#{collection}", activity.to_json
          end
        end
      end
    end
  end
end
