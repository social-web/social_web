# frozen_string_literal: true

ENV['SOCIAL_WEB_DATABASE_URL'] = 'postgresql://localhost/social_web_test'

require 'rack/test'

require 'social_web/rack'
require_relative './helpers/rack_helper'

class RackSpecContainer
  extend Dry::Container::Mixin

  register(:dereference) do
    dereference = Object.new
    def dereference.call(iri)
      object = OpenStruct.new
      object.inbox = "#{iri}/inbox"
      object
    end
    dereference
  end
end

RSpec.configure do |config|
  config.include ::RackHelper
  config.include ::Rack::Test::Methods, type: :request

  config.around(:example) do |example|
    SocialWeb::Rack['db'].transaction(rollback: :always, &example)
  end
end
