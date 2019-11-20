# frozen_string_literal: true

require 'activity_streams'

module ActivityStreams
  module Extensions
    module ActivityPub
      def self.included(base)
        base.class_eval do
          property :inbox
          property :outbox
          property :publicKey
        end
      end
    end
  end
end

module ActivityStreams
  module Extensions
    module ActivityPub
      module Collection
        def self.included(base)
          base.class_eval do
            def next
              @next_iri = super
              SocialWeb['collections'].get(@next_iri)
            end
          end
        end
      end
    end
  end
end
