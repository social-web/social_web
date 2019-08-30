# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  class Routes
    module Helpers
      RSpec.describe RequestHelpers, type: :request do
        describe '#warden' do
          it 'authenticates with the warden object if available' do
            warden = double('warden')
            expect(warden).to receive(:authenticate)

            env 'warden', warden
            get '/inbox'
          end
        end
      end
    end
  end
end
