# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  module Services
    RSpec.describe Follow do
      describe '.deliver' do
        it 'delivers the object' do
          follow = build :stream, type: 'Follow'
          object = build :stream, type: 'Person', inbox: 'https://example.com/2'
          follow.object = object

          expect(Delivery).
            to receive(:call).
            with(object.inbox, follow.to_json)
          described_class.deliver(follow)
        end
      end
    end
  end
end
