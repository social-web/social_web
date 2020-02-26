# frozen_string_literal: true

module SocialWeb
  module Collections
    class Outbox < SocialWeb::Collection
      TYPE = 'Outbox'

      def process(activity)
        # "If an Activity is submitted with a value in the id property, servers MUST ignore this
        # and generate a new id for the Activity."
        # - https://www.w3.org/TR/activitypub/#client-to-server-interactions
        activity[:id] = generate_id

        add(activity)

        case activity[:type]
        when 'Follow'
          SocialWeb['services.http_client'].
            for_actor(actor).
            post(object: activity, to_collection: activity[:object][:inbox])
        end
      end

      private

      def generate_id
        format(
          '%<scheme>s://%<host>s/social_web/objects/%<slug>s',
          scheme: 'https',
          host: SocialWeb[:config].hostname,
          slug: SecureRandom.hex
        )
      end
    end
  end
end
