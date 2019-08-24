# frozen_string_literal: true

require 'spec_helper'

module ActivityPub
  RSpec.describe 'Object' do
    describe 'inbox.post.before hook' do
      it 'adds the activity to the Inbox' do
        act = ActivityStreams::Object.new
        act.original_json = { 'type' => 'Create' }
        expect { Hooks.run('inbox.post.before', activity: act) }.
          to change { Object.count }.by(+1)
      end
    end
  end
end
