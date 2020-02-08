# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Routes, type: :request do
    context 'POST' do
      describe 'inbox' do
        it "adds the item to the actor's inbox" do
          actor = create :object, iri: 'http://example.org/actor'
          activity = create :object
          header('accept', 'application/activity+json')
          post '/actor/inbox', activity.to_json
        end
      end
    end
  end
end
