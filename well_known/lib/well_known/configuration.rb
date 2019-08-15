# frozen_string_literal: true

module WellKnown
  class Configuration
    attr_accessor :webfinger_resource

    def initialize
      @webfinger_resource = {}
    end
  end
end
