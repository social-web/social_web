# frozen_string_literal: true

require_relative './rack/system/container'

module SocialWeb
  module Rack
    def self.start!
      SocialWeb::Rack::Container.finalize!
    end
  end
end
