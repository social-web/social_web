# frozen_string_literal: true

FactoryBot.define do
  to_create { |obj| obj.save }

  factory :activity, class: SocialWeb::Activities do
    sequence(:_id) { |n| "https://example.com/#{n}" }
    collection { 'Inbox' }
    type { 'Create' }
    json {
      {
        '@context' => ActivityStreams::NAMESPACE,
        id: _id,
        type: type,
        object: {
          id: 'https://example.com/1',
          type: 'Note'
        }
      }.to_json
    }
  end

  factory :stream, class: ActivityStreams do
    initialize_with do
      ActivityStreams.from_json(
        JSON.dump(attributes.merge('@context' => attributes.delete(:_context)))
      )
    end

    _context { ActivityStreams::NAMESPACE }
    sequence(:id) { |n| "https://example.com/#{n}"}
    type { 'Create' }
  end
end