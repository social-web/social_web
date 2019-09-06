# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Actors do
    describe '.by_iri' do
      it 'find an object by iri' do
        object = create :actor
        found_object = described_class.by_iri(object.iri)
        expect(found_object.id).to eq(object.iri)
      end
    end
  end
end
