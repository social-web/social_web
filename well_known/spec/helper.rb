# frozen_string_literal: true

module Helper
  def app
    builder = Rack::Builder.new
    builder.run WellKnown::Routes
  end

  def configure
    mock_config = instance_double('WellKnown::Configuration')
    allow(WellKnown).to receive(:config).and_return(mock_config)
    yield mock_config
  end
end
