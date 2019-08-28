# frozen_string_literal: true

require 'implementation_spec_helper'

RSpec.describe 'Follow', type: :request do
  it 'delivers' do
    follow = build :stream, type: 'Follow'
    object = build :stream, type: 'Person'
    follow.object = object

    expect(SocialWeb::Delivery).to receive(:call).with(kind_of(follow.class))
    post '/outbox', follow.to_json
  end

  it 'receives' do
    follow = build :stream, type: 'Follow'
    object = build :stream, type: 'Person'
    follow.object = object


    post '/inbox', follow.json
  end
end
