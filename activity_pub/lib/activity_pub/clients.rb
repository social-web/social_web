# frozen_string_literal: true

require 'activity_pub/clients/http'

module ActivityPub
  module Clients
    def self.http
      Clients::HTTP
    end
  end
end
