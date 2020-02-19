# frozen_string_literal: true

module ActivityStreams
  module Extensions
    module ActivityPub
      def self.extended(base)
        base.class_eval do
          property :inbox
          property :outbox
          property :publicKey
        end
      end
    end
  end
end