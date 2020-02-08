# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Routes, type: :request do
    context 'POST' do
      %w[inbox outbox].each do |collection|
        describe collection do
          it "adds the item to the actor's #{collection}" do
            actor = create :object
            activity = build :object

            expect(SocialWeb).
              to receive(:process).
              with(activity.to_json, actor[:id], collection)

            header('accept', 'application/activity+json')
            post "#{actor[:id]}/#{collection}", activity.to_json
          end
        end
      end
    end
  end
end
