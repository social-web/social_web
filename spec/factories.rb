# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :collection, parent: :object do
    to_create do |instance|
      SocialWeb['repositories.collections'].get_collection_for_actor(
        actor: for_actor,
        collection: name
      )
    end

    id { [for_actor[:id], name].join('/') }
    type { 'Collection' }
    items { [] }

    transient do
      :for_actor
      :name
    end

    after(:build) do |collection, evaluator|
      collection[:items].each do |item|
        SocialWeb['repositories.collections'].
          store_object_in_collection_for_actor(
            object: item,
            collection: evaluator.name,
            actor: evaluator.for_actor
          )
      end
    end
  end

  factory :object, class: ActivityStreams do
    initialize_with { ActivityStreams.new(**attributes) }
    to_create { |instance| SocialWeb['repositories.objects'].store(instance) }

    id { "https://example.org/social_web/#{SecureRandom.hex}"}
  end
end
