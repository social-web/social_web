# frozen_string_literal: true

module SocialWeb; end

def SocialWeb(activity_json, actor_iri, collection)
  activity = ActivityStreams.from_json(activity_json)
  actor = SocialWeb['repositories.objects'].get_by_iri(actor_iri)
  SocialWeb['services.dereference'].for_actor(actor).call(activity)
  SocialWeb["collections.#{collection}"].for_actor(actor).process(activity)
end
