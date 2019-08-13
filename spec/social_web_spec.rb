# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SocialWeb do
  describe '.new' do
    it 'delegates to Routes' do
      expect(SocialWeb::Routes).to receive(:new)
      described_class.new(nil)
    end

    it 'supports Rails' do
      require 'rails'
      require 'action_controller/railtie'

      expect(described_class).to receive(:call)
      rails.call({ 'REQUEST_METHOD' => 'GET', 'rack.input' => '' })
    end

    private

    def rails
      rails_app = Class.new(Rails::Application).instance
      rails_app.config.eager_load = false
      rails_app.initialize!
      rails_app.routes.draw { mount SocialWeb, at: '/' }
      rails_app
    end
  end
end
