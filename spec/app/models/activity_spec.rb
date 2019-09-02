# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Activity do
    describe '.receive' do
      it 'persist an activity and its object' do
        act = build :stream, object: build(:stream)
        actor = create :actor
        expect { described_class.process(act, actor: actor, collection: 'inbox') }.
          to change { Activities.count }.by(+1)
      end
    end
  end

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
  end
end
