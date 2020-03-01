# frozen_string_literal: true

SocialWeb::Container.boot :activity_pub do
  init do
    require 'social_web/activity_pub/boot'
  end
end
