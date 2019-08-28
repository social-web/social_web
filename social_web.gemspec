# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'social_web'
  s.version = '0.1'
  s.summary = 'Framework for the Social Web'
  s.description = 'A suite of apps and tools for participating in the social ' \
    'web.'

  s.license = 'MIT'

  s.authors = ['Shane Cavanaugh']
  s.email = ['shane@shanecav.net']
  s.homepage = 'https://github.com/social-web'

  s.files = %w[README.md Rakefile LICENSE.txt] + Dir['{social_web}/**/*']
  s.require_path = 'lib'

  s.required_ruby_version = '>= 2.5.0'

  s.add_dependency 'http'
  s.add_dependency 'social_web-activity_streams'
  s.add_dependency 'pg'
  s.add_dependency 'roda'
  s.add_dependency 'sequel'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'rack-test', '~> 1.0'
  s.add_development_dependency 'rails', '>= 5.2.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'simplecov', '~> 0.1'
  s.add_development_dependency 'sqlite3'
end
