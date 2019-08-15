# frozen_string_literal: true

module Helper
  def app
    builder = Rack::Builder.new
    builder.run ActivityPub::Routes
  end

  def configure
    mock_config = instance_double('ActivityPub::Configuration')
    allow(ActivityPub).to receive(:config).and_return(mock_config)
    yield mock_config
  end
end
