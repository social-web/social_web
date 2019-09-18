# frozen_string_literal: true

require 'implementation_spec_helper'

RSpec.describe 'Follow', type: :request do
  it 'adds actor to outbox after accept is received' do
    follow = build :stream, type: 'Follow'
    follow.actor = build :stream, type: 'Person'
    follow.object = build :stream, type: 'Person'

    SocialWeb.process(follow, follow.actor, 'outbox')

    accept = build :stream, type: 'Accept'
    accept.actor = build :stream, type: 'Person'
    accept.object = follow

    SocialWeb.process(accept, accept.actor, 'inbox')

    expect(
      SocialWeb.config.container['collections.following'].
        for_actor(follow.actor).
        includes?(accept.actor)
    ).to eq(true)
  end
end
