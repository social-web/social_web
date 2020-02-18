# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SocialWeb do
  describe '.process' do
    %i[inbox outbox].each do |collection|
      it "stores, dereferences, and forwards to #{collection}" do
        actor = create :object
        activity = build :object

        stubbed_collection = instance_double(SocialWeb["collections.#{collection}"])

        expect(SocialWeb["collections.#{collection}"]).
          to receive(:for_actor).
          with(actor).
          and_return(stubbed_collection)
        expect(SocialWeb['repositories.objects']).
          to receive(:store).
          with(activity)

        dereferencer = instance_double(SocialWeb['services.dereference'])
        expect(SocialWeb['services.dereference']).
          to receive(:for_actor).
          with(actor).
          and_return(dereferencer)
        expect(dereferencer).to receive(:call).with(activity)

        expect(stubbed_collection).to receive(:process).with(activity)

        described_class.process(activity.to_json, actor[:id], collection)
      end
    end
  end
end
