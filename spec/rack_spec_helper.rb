# frozen_string_literal: true

ENV['DATABASE_URL'] = 'postgresql://localhost/social_web_test'

require 'social_web/rack'
require_relative './helpers/web_helper'

RSpec.configure do |config|
  config.include ::WebHelper

  config.around(:example) do |example|
    SocialWeb::Rack.db.transaction(rollback: :always, &example)
  end
end
