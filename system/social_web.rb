# frozen_string_literal: true

require 'social_web/container'

SocialWeb::Container.tap do |container|
  container.start :logging
  container.start :configuration
end

module SocialWeb
  def self.start!
    SocialWeb::Container.finalize!
  end
end
