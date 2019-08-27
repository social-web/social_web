# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  class Routes
    RSpec.describe '/.well-known', type: :request do
      context '/.well-known/webfinger' do
        describe 'get /.well-known/webfinger?resource=:acct' do
          it 'returns the :acct' do
            get '/.well-known/webfinger?resource=acct:shane@shanecav.net'

            expect(last_response.status).to eq(200)
            expect(JSON.parse(last_response.body)['subject']).
              to eq('acct:shane@shanecav.net')
          end
        end
      end
    end
  end
end
