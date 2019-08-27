# frozen_string_literal: true

require 'sequel'

Rake.load_rakefile 'social_web/tasks/db.rake'

module SocialWeb
  def self.db
    @db ||= Sequel.connect(SocialWeb.configuration.database_url)
  end
end
