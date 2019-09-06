# frozen_string_literal: true

FactoryBot.define do
  to_create { |obj| obj.save }

  factory :activity, class: SocialWeb::Activities do
    sequence(:iri) { |n| "https://example.com/#{n}" }
    type { 'Create' }
    json {
      {
        '@context' => ActivityStreams::NAMESPACE,
        id: iri,
        type: type,
        object: {
          id: 'https://example.com/1',
          type: 'Note'
        }
      }.to_json
    }
    created_at { Time.now.utc }
  end

  factory :actor, class: SocialWeb::Actors do
    sequence(:iri) { |n| "https://example.com/actors/#{n}" }
    json {
      {
        '@context' => ActivityStreams::NAMESPACE,
        id: iri,
        type: 'Person'
      }.to_json
    }
    created_at { Time.now.utc }
  end

  factory :stream, class: ActivityStreams do
    initialize_with do
      ActivityStreams.from_json(JSON.dump(attributes))
    end

    sequence(:id) { |n| "https://example.com/#{n}"}
    type { 'Create' }
  end
end
