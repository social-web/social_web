# frozen_string_literal: true

module SocialWeb
  module Activities
    class Create < ActivityStreams::Activity::Create
      def self.deliver(create); end

      def self.receive(create); end
    end
  end
end
