# frozen_string_literal: true

module SocialWeb
  module Services
    class Accept
      def self.deliver(accept)
        target_inbox = ActivityStreams.from_uri(accept.object.id).inbox
        Delivery.call(target_inbox, follow.to_json)
      end

      def self.receive(accept)
        case accept.object.type
        when 'Follow' then
        end
      end
    end
  end
end
