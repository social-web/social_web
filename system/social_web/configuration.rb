# frozen_string_literal: true

module SocialWeb
  extend ::Dry::Configurable

  setting(:logger, SocialWeb[:logger])
  setting(:collections, %i[inbox outbox].freeze) { |collection| Array(collection).freeze }
  setting(:hostname)

  # When traversing an ActivityStream's property tree, how deep should we go
  # Default: Float::INFINITY
  setting :max_depth, 200
end
