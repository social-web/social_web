# frozen_string_literal: true

require 'social_web/container'

SocialWeb::Container.finalize!(freeze: false) do |container|
  container.start :activity_streams
end
