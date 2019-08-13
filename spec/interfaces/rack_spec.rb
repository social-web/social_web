# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Rack support' do
  it 'can be used as middleware' do
    expect(SocialWeb::Routes).to receive(:new)

    app = Rack::Builder.app do
      use SocialWeb
      run ->(env) { [200, {'Content-Type' => 'text/plain'}, ['OK']] }
    end
    Rack::Builder.new.run app
  end

  it 'can be run as an app' do
    expect(SocialWeb::Routes).to receive(:call)

    Rack::Builder.app { run SocialWeb }.call({})
  end
end
