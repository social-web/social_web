# frozen_string_literal: true

module SocialWeb
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  class Configuration
    attr_accessor :loggers

    # When traversing an ActivityStream's property tree, how deep should we go
    # Default: Float::INFINITY
    attr_accessor :max_depth

    def loggers=(val)
      @loggers ||= []
      @loggers += Array(val)
    end
  end
end
