# frozen_string_literal: true

module SocialWeb
  module Collections
    class Outbox < SocialWeb::Collection
      TYPE = 'Outbox'

      def process(activity)
        add(activity)

        case activity[:type]
        when 'Follow'
          SocialWeb['services.http_client'].
            for_actor(actor).
            post(activity[:object][:id], activity)
        end
      end
    end
  end
end
