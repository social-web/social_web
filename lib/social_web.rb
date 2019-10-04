# frozen_string_literal: true

require 'bundler/setup'

require_relative './activity_streams_extension'
require 'social_web/configuration'
require 'social_web/container'

module SocialWeb
  def self.container
    @container ||= SocialWeb::Container.merge(SocialWeb.config.container)
  end

  def self.process(activity_json, actor, collection)
    raise unless %w[inbox outbox].include?(collection)

    activity = ActivityStreams.from_json(activity_json)

    container['repositories.activities'].store(activity, actor, collection)
    handler = container.resolve(
      "collections.#{collection}.#{activity.type.downcase}"
    ) {}
    handler&.call(activity)
  end
end
