# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Activity::Dereference do
    it 'requests the IRI' do
      act = build :stream, object: 'https://example.com/1'
      expect(Client).to receive(:get).with(act.object)

      expect(described_class).
        to receive(:call).
        with(act).
        and_call_original.
        ordered

      expect(described_class).
        to receive(:call).
        with(act.object).
        and_call_original.
        ordered

      described_class.call(act)
    end

    it 'derereferences an ActivityStreams::Model' do
      object = double('object')
      act = build :stream
      act.object = 'https://example.com'
      expect(Client).to receive(:get).with(act.object).and_return(object)
      expect { described_class.call(act) }.
        to change { act.object }.to(object)
    end
  end
end
