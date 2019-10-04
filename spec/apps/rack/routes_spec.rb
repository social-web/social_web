# frozen_string_literal: true

require 'rack_spec_helper'

module SocialWeb
  module Rack
    RSpec.describe Routes, type: :request do
      %w[inbox outbox].each do |collection|
        describe "/#{collection}" do
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
