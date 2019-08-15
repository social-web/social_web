# frozen_string_literal: true

module Helper
  def app
    builder = Rack::Builder.new
    builder.run Webmention::Route
  end

  def configure
    mock_config = instance_double('Webmention::Configuration')
    allow(Webmention).to receive(:config).and_return(mock_config)
    yield mock_config
  end
end
