# frozen_string_literal: true

module SocialWeb
  module Rack
    module Relations
      class Relationships < Sequel::Model(SocialWeb::Rack.db[:social_web_relationships])

      end
    end
  end
end
