# frozen_string_literal: true

module RackHelper
  def app
    Rack::Builder.app do
      use SocialWeb::Rack
      run -> { raise 'This should not be reached '}
    end
  end

  def create_activity(for_actor: nil, collection: nil)
    iri = "https://example.org/activities/#{Random.rand(1000)}"
    json = %({
      "@context": "https://www.w3.org/ns/activitystreams",
      "id": "#{iri}",
      "type": "Create",
      "object": {
        "id": "https://example.org/activities/2",
        "type": "Note"
      }
    })

    id = SocialWeb::Rack['db'][:social_web_activities].insert(
      iri: iri,
      json: json,
      type: 'Create',
      created_at: Time.now.utc
    )

    if for_actor
      SocialWeb::Rack['db'][:social_web_actor_activities].insert(
        collection: collection || 'inbox',
        actor_iri: for_actor.id,
        activity_iri: iri,
        created_at: Time.now.utc
      )
    end

    ActivityStreams.from_json(json)
  end

  def create_actor
    actor = ActivityStreams.from_json({
      '@context' => 'https://www.w3.org/ns/activitystreams',
      'id' => 'http://example.org/actors/1',
      'type' => 'Person'
    }.to_json)

    SocialWeb['objects'].store(actor)
    actor
  end
end
