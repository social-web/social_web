# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SocialWeb do
  describe '.new' do
    it 'delegates to Routes' do
      expect(SocialWeb::Routes).to receive(:new)
      described_class.new(nil)
    end
  end
end
