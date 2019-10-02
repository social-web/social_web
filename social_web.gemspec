# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'social_web'
  s.version = '0.1'
  s.summary = 'Framework for the Social Web'
  s.description = 'A suite of apps and tools for participating in the social ' \
    'rack.'

  s.license = 'MIT'

  s.authors = ['Shane Cavanaugh']
  s.email = ['shane@shanecav.net']
  s.homepage = 'https://github.com/social-rack'

  s.files = %w[README.md Rakefile LICENSE.txt] + Dir['{apps,lib}/**/*']
  s.require_paths = %w[lib]

  s.required_ruby_version = '>= 2.5.0'

  # Provides easy access to an HTTP client
  s.add_dependency 'http'

  # Provides Ruby models to represent Activity Streams objects
  s.add_dependency 'social_web-activity_streams'

  # Provides a framework for efficient routing of requests
  s.add_dependency 'roda'

  # Provides a database toolkit for persistance
  s.add_dependency 'sequel'

  # Provides simple templating of HTML documents
  s.add_dependency 'slim'
  # Supports 'slim'
  s.add_dependency 'tilt'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'dry-auto_inject'
  s.add_development_dependency 'dry-container'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rack-test', '~> 1.0'
  s.add_development_dependency 'rails', '>= 5.2.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'simplecov', '~> 0.1'
  s.add_development_dependency 'sqlite3'
end
