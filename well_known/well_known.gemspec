# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'social_web-well_known'
  s.version = '0.1'
  s.authors = ['Shane Cavanaugh']
  s.email = ['shane@shanecav.net']

  s.summary = 'Ednpoints for Well-Known URIs'
  s.description = s.summary
  s.homepage = 'https://github.com/social-web/well_known'
  s.license = 'MIT'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = s.homepage
  s.metadata['changelog_uri'] = 'https://github.com/social-web/well_known/tree/master/CHANGELOG.md'

  s.files = %w[LICENSE.txt] + Dir['{lib,spec}/**/*']
  s.require_path = 'lib'

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency 'dry-events'
  s.add_dependency 'roda', '~> 3.0'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'rack-test', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'simplecov', '~> 0.1'
end
