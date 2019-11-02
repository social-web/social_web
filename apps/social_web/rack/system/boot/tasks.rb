# frozen_string_literal: true

SocialWeb::Rack::Container.boot :tasks do
  init do
    require 'rake'
  end

  start do
    Rake.load_rakefile 'social_web/rack/tasks/db.rake'
  end
end
