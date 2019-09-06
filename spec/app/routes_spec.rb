# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Routes, type: :request do
    it 'creates a new actor automatically' do
      expect { get '/users/1/inbox' }.
        to change { Actors.count }.by(+1)
      expect(JSON.parse(Actors.all.first.json)).to eq(
        'id' => 'http://example.org/users/1',
        'type' => 'Person',
        'inbox' => 'http://example.org/users/1/inbox',
        'outbox' => 'http://example.org/users/1/outbox'
      )
    end
  end
end
