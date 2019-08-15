# frozen_string_literal: true

module ActivityPub
  def self.configure
    yield config
  end

  def self.config
    @configuration ||= Configuration.new
  end

  class Configuration; end
end
