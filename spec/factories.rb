# frozen_string_literal: true

FactoryBot.define do
  factory :object, class: ActivityStreams::Object do
    to_create { |instance| SocialWeb['repositories.objects'].store(instance) }

    id { 'http://example.org' }
    type { 'Create' }
    json { ActivityStreams.create(iri: iri, type: type).to_json }
    created_at { Time.now }
  end
end
