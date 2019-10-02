# frozen_string_literal: true

module WebHelper
  def create_activity(for_actor: nil)
    iri = 'https://example.org/activities/1'
    json = {
      '@context' => 'https://www.w3.org/ns/activitystreams',
      'id' => iri,
      'type' => 'Create'
    }.to_json

    id = SocialWeb::Rack.db[:social_web_activities].insert(
      iri: iri,
      json: json,
      type: 'Create',
      created_at: Time.now.utc
    )

    if for_actor
      SocialWeb::Rack.db[:social_web_actor_activities].insert(
        collection: 'inbox',
        actor_iri: for_actor.id,
        activity_iri: iri,
        created_at: Time.now.utc
      )
    end

    ActivityStreams.from_json(json)
  end

  def create_actor
    json = {
      '@context' => 'https://www.w3.org/ns/activitystreams',
      'id' => 'https://example.org/actors/1',
      'type' => 'Person'
    }.to_json

    SocialWeb::Rack.db[:social_web_actors].insert(
      iri: "https://example.org/actors/1",
      json: json,
      created_at: Time.now.utc
    )

    ActivityStreams.from_json(json)
  end
end
