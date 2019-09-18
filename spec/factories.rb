# frozen_string_literal: true

FactoryBot.define do
  factory :stream, class: ActivityStreams do
    initialize_with do
      ActivityStreams.from_json(JSON.dump(attributes))
    end

    sequence(:id) { |n| "https://example.com/#{n}"}
    type { 'Create' }
  end
end
