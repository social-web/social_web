# frozen_string_literal: true

FactoryBot.define do
  to_create { |instance| instance.save }

  factory :activity, class: ActivityPub::Activity do
    sequence(:uri) { |n| "https://example.com/#{n}" }
    collection { 'inbox' }
    created_at { Time.now }

    before(:create) do |act|
      obj = create :object
      json = {
        '@context' => 'https://www.w3.org/ns/activitystreams',
        type: 'Create',
        id: act.uri,
        object: JSON.parse(obj.json)
      }
      act.json = json.to_json
      act.activity_pub_object_id = obj.id
    end
  end

  factory :object, class: ActivityPub::Object do
    sequence(:uri) { |n| "https://example.com/#{n}" }
    created_at { Time.now }

    before(:create) do |obj|
      obj.json = {
        '@context' => 'https://www.w3.org/ns/activitystreams',
        id: obj.uri,
        type: 'Note'
      }.to_json
    end
  end
end
