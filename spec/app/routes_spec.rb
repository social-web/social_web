# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Routes, type: :request do
    it 'creates a new actor automatically' do
      expect { get '/example.com/users/1/inbox' }.
        to change { Actors.count }.by(+1)
    end
  end
end
