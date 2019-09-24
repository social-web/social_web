# frozen_string_literal: true

require 'sequel'

module SocialWeb
  module Web
    def self.db
      @db ||= Sequel.connect(ENV['DATABASE_URL'])
    end
  end
end
