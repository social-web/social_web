# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'social_web'
  s.version = '0.1'
  s.summary = 'Framework for the Social Web'
  s.description = 'A suite of apps and tools for participating in the social web'

  s.license = 'MIT'

  s.authors = ['Shane Cavanaugh']
  s.email = ['shane@shanecav.net']
  s.homepage = 'https://github.com/social-web'

  s.files = %w[README.md Rakefile LICENSE.txt] + Dir['{db,lib,system}/**/*']
  s.require_paths = %w[system]

  s.required_ruby_version = '>= 2.5.0'

  s.add_dependency 'dry-container'
  s.add_dependency 'dry-configurable'
  s.add_dependency 'dry-system'

  s.add_development_dependency 'sqlite3'

  s.add_development_dependency 'bundler', '~> 2.0'
end
