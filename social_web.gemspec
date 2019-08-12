# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'social_web'
  s.version = '0.1'
  s.authors = ['Shane Cavanaugh']
  s.email = ['shane@shanecav.net']

  s.summary = 'Framework for the Social Web'
  s.description = 'A suite of apps and tools for participating in the social ' \
    'web.'
  s.homepage = 'https://github.com/social-web'
  s.license = 'MIT'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = s.homepage
  s.metadata['changelog_uri'] = 'https://github.com/social-web/tree/master/CHANGELOG.md'

  s.files = %w[LICENSE.txt] + Dir['{lib,spec}/**/*']
  s.require_path = 'lib'

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency 'social_web-activity_pub', '~> 0.1'
  s.add_dependency 'social_web-activity_streams', '~> 0.1'
  s.add_dependency 'social_web-webmention', '~> 0.1'
  s.add_dependency 'social_web-well_known', '~> 0.1'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'rack-test', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'simplecov', '~> 0.1'
end
