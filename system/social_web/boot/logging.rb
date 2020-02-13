# frozen_string_literal: true

SocialWeb::Container.boot :logging do
  init do
    require 'logger'

    require 'social_web/logger'
    register(:logger, SocialWeb::Logger.new(STDOUT))
  end
end
