# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  RSpec.describe Activity do
    describe '.receive' do
      it 'persist an activity and its object' do
        act = build :stream, object: build(:stream)
        expect { described_class.process(act, collection: 'inbox') }.
          to change { Activities.count }.by(+1)
      end
    end
  end
end
