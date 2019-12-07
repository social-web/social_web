# frozen_string_literal: true

SocialWeb::Container.boot :activity_streams do
  init do
    require 'activity_streams'
    require 'social_web/ext/activity_streams_extension'
  end

  start do
    ActivityStreams::Model.include ActivityStreams::Extensions::ActivityPub
  end
end
