# frozen_string_literal: true

namespace :db do
  task :reset do
    %w[dev test].each do |env|
      db = "social_web_#{env}"
      `dropdb #{db}`
      `createdb #{db}`
      `sequel -m db/migrations postgres://localhost/#{db}`
    end
  end
end
