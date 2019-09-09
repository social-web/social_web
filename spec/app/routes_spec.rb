# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Routes, type: :request do
    context 'authentication' do
      it 'allows an authenticated user to post to their outbox' do
        actor = create :actor, iri: 'http://example.org'
        login_as(actor)

        stream = build :stream
        allow(Activity).to receive(:process)

        post '/outbox', stream.to_json
        expect(last_response.status).to eq(201)
      end

      it 'does not allow an authenticated user to post to their outbox' do
        stream = build :stream
        allow(Activity).to receive(:process)

        post '/outbox', stream.to_json
        expect(last_response.status).to eq(403)
      end
    end
  end
end
