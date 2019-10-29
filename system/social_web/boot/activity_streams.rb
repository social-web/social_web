# frozen_string_literal: true

SocialWeb::Container.boot :activity_streams do
  init do
    require 'activity_streams'
  end
end
