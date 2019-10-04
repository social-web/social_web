# frozen_string_literal: true

require 'sequel'

module SocialWeb
  module Rack
    def self.db
      @db ||= Sequel.connect(ENV['SOCIAL_WEB_DATABASE_URL'])
    end
  end
end
