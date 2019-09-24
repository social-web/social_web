# frozen_string_literal: true

require 'activity_streams'

module ActivityStreams
  module Extensions
    module ActivityPub
      def self.included(base)
        base.class_eval do
          property :inbox
          property :outbox
        end
      end
    end
  end
end

ActivityStreams::Model.include ActivityStreams::Extensions::ActivityPub
