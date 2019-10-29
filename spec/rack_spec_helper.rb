# frozen_string_literal: true

ENV['SOCIAL_WEB_DATABASE_URL'] = 'postgresql://localhost/social_web_test'

require 'rack/test'
require 'social_web/rack'

require_relative './rack_spec_container'
require_relative './helpers/rack_helper'

RSpec.configure do |config|
  config.include ::RackHelper
  config.include ::Rack::Test::Methods, type: :request

  config.around(:example) do |example|
    SocialWeb::Rack['db'].transaction(rollback: :always, &example)
  end
end
