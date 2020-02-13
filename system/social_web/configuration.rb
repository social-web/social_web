# frozen_string_literal: true

module SocialWeb
  extend ::Dry::Configurable

  setting(:loggers, [SocialWeb[:logger].new(STDOUT)]) { |logger| Array(logger).freeze }
  setting(:collections, %i[inbox outbox].freeze) { |collection| Array(collection).freeze }

  # When traversing an ActivityStream's property tree, how deep should we go
  # Default: Float::INFINITY
  setting :max_depth, 200
end
