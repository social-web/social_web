# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'social_web-activity_pub'
  s.version = '0.1'
  s.authors = ['Shane Cavanaugh']
  s.email = ['shane@shanecav.net']

  s.summary = 'Rack app for ActivityPub endpoints'
  s.description = s.summary
  s.homepage = 'https://github.com/social-web/activity_pub'
  s.license = 'MIT'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = s.homepage
  s.metadata['changelog_uri'] = 'https://github.com/social-web/activity_pub/tree/master/CHANGELOG.md'

  s.files = %w[LICENSE.txt] + Dir['{lib,spec}/**/*']
  s.require_path = 'lib'

  s.required_ruby_version = '>= 2.5.5'

  s.add_dependency 'social_web-activity_streams'
  s.add_dependency 'http', '~> 4.0'
  s.add_dependency 'roda', '~> 3.0'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'rack-test', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'simplecov', '~> 0.1'
end
