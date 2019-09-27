# frozen_string_literal: true

ENV['DATABASE_URL'] = 'postgresql://localhost/social_web_test'

require_relative '../apps/web.rb'
require_relative './helpers/web_helper'

RSpec.configure do |config|
  config.include ::WebHelper

  config.around(:example) do |example|
    SocialWeb::Web.db.transaction(rollback: :always, &example)
  end
end
