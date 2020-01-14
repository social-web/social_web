# frozen_string_literal: true

module SocialWeb
  module Rack
    module Models
      class Collection
        def self.for_actor(actor, collection)
          new(actor, collection)
        end

        def << item

        end

        def items
          SocialWeb['']
        end

        def to_s

        end
      end
    end
  end
end
