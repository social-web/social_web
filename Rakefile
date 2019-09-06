# frozen_string_literal: true

require 'bundler/setup'
require 'social_web'

SocialWeb.config.database_url = if ENV['RACK_ENV'] == 'test'
  'postgresql://localhost/social_web_test'
else
  'postgresql://localhost/social_web_dev'
end
