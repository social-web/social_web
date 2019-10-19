# frozen_string_literal: true

require 'rack_spec_helper'

module SocialWeb
  module Rack
    module Repositories
      RSpec.describe Keys do
        let(:keys) { described_class.new }

        describe '#for_actor_iri' do
          it "returns an actor's keys" do
            actor = create_actor

            %i[key_id private public].each do |col|
              expect(keys.for_actor_iri(actor.id)[col]).
                to be_a(String)
            end
          end
        end
      end
    end
  end
end
