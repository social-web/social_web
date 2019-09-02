# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Actors do
    describe '.by_iri' do
      it 'find an object by iri' do
        object = create :actor
        expect(described_class.by_iri(object.iri)).to eq(object)
      end
    end
  end
end
