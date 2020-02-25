# frozen_string_literal: true

module SocialWeb
  def self.process(activity_json, actor_iri, collection)
    SocialWeb[:config].logger.debug <<~MSG
      Processing:

      activity_json: #{activity_json}
      actor_iri: #{actor_iri}
      collection: #{collection}
    MSG

    activity = ActivityStreams.from_json(activity_json)
    actor = SocialWeb['repositories.objects'].get_by_iri(actor_iri)

    SocialWeb['repositories.objects'].store(activity)
    SocialWeb['services.dereference'].for_actor(actor).call(activity)
    activity = SocialWeb['services.reconstitute'].call(activity)

    SocialWeb["collections.#{collection}"].for_actor(actor).process(activity)
  end
end
