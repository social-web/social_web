# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Rails support' do
  let(:rails) {
    require 'rails'
    require 'action_controller/railtie'

    rails_app = Class.new(Rails::Application).instance
    rails_app.config.eager_load = false
    rails_app.initialize!
    rails_app
  }

  it 'is mountable' do
    expect(SocialWeb::Routes).to receive(:call)
    rails.routes.draw { mount SocialWeb, at: '/' }
    rails.call({ 'REQUEST_METHOD' => 'GET', 'rack.input' => '' })
  end
end
