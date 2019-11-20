# frozen_string_literal: true

require 'rack_spec_helper'

module SocialWeb
  module Rack
    module Repositories
      RSpec.describe Objects do
        describe '#store' do
          it 'persists the activity' do
            activity = ActivityStreams.create {
              type 'Create'
              id 'https://example.org/activities/1'
            }

            expect { described_class.new.store(activity) }.
              to change { SocialWeb::Rack['db'][:social_web_objects].count }.
              by(+1)
          end

          it 'recursively stores objects' do
            child = ActivityStreams.create {
              type 'Create'
              id 'https://example.org/activities/1'
              object ActivityStreams.note {
                id 'https://example.org/notes/1'
                type 'Note'
              }
            }
            described_class.new.store(child)
          end
        end
      end
    end
  end
end
