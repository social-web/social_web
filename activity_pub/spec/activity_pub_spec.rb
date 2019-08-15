# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActivityPub do
  describe '.confgure' do
    it 'yields the configuration' do
      expect(described_class.configure(&:itself)).
        to be_a(ActivityPub::Configuration)
    end
  end

  describe '.configuration' do
    it 'returns configuration' do
      expect(described_class.config).to be_a(ActivityPub::Configuration)
    end
  end
end
