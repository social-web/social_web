# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :object, class: ActivityStreams do
    initialize_with { ActivityStreams.new(attributes) }
    to_create { |instance| SocialWeb['repositories.objects'].store(instance) }

    id { "https://example.org/objects/#{SecureRandom.hex}"}
  end
end
