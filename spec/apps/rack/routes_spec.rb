# frozen_string_literal: true

require 'rack_spec_helper'

module SocialWeb
  module Rack
    RSpec.describe Routes, type: :request do
      describe 'get /' do
        it 'returns actor' do
          actor = create_actor
          keys = SocialWeb.container['repositories.keys'].for_actor_iri(actor.id)
          actor.publicKey = {
            id: keys[:key_id],
            owner: actor.id,
            publicKeyPem: keys[:public]
          }
          header('Accept', 'application/activity+json')
          get '/actors/1'
          expect(last_response.body).to eq(actor.to_json)
        end
      end

      %w[inbox outbox].each do |collection|
        describe "get /#{collection}" do
          it 'gets the collection' do
            actor = create_actor
            act = create_activity(for_actor: actor, collection: collection)

            get "/actors/1/#{collection}"
            expect(last_response.body).to include(collection.capitalize)
            expect(last_response.body).to include(act.type)
          end
        end

        describe "post /#{collection}" do
          it 'passes along to SocialWeb' do
            actor = create_actor
            json = %({
              "id": "https://example.org/activities/1",
              "type": "Create"
            })

            expect(SocialWeb).
              to receive(:process).
              with(json, actor.id, collection)

            post "/actors/1/#{collection}", json
          end
        end
      end
    end
  end
end
