# frozen_string_literal: true

module ActivityStreams
  def self.from_uri(uri)
    uri = URI(uri)
    res = HTTP.follow.get(uri)
    ActivityStreams.from_json(res.body.to_s)
  end
end

module SocialWeb
  module Activities
    class Follow < ActivityStreams::Activity::Follow
      def self.deliver(follow)
        target_inbox = ActivityStreams.from_uri(follow.object.id).inbox
        Delivery.call(target_inbox, follow.to_json)
      end

      def self.receive(follow); end
    end
  end
end
