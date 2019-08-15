# frozen_string_literal: true

require 'activity_pub/clients/http'
require 'activity_pub/clients/activity_pub'

module ActivityPub
  module Clients
    def self.activity_pub
      Clients::ActivityPub
    end

    def self.http
      Clients::HTTP
    end
  end
end
