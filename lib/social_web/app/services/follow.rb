# frozen_string_literal: true

module SocialWeb
  module Services
    class Follow < ActivityStreams::Activity::Follow
      def self.deliver(follow)
        target_inbox = ActivityStreams.from_uri(follow.object.id).inbox
        Delivery.call(target_inbox, follow.to_json)
      end

      def self.receive(follow); end
    end
  end
end
