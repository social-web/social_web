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

  def build_activity
    {
      '@context' => 'https://www.w3.org/ns/activitystreams',
      id: "https://example.com/#{Random.rand(1000)}",
      type: %w[Create Update Delete].sample,
      object: {
        id: "https://example.com/#{Random.rand(1000)}",
        type: %w[Note].sample
      }
    }
  end

  def get(*args, **kwargs)
    header 'accept',
      'application/ld+json; profile="https://www.w3.org/ns/activitystreams"'
    super
  end

  def post(*args, **kwargs)
    header 'content-type',
      'application/ld+json; profile="https://www.w3.org/ns/activitystreams"'
    super
  end
end
