# frozen_string_literal: true

ENV['DATABASE_URL'] ||= 'postgres://localhost/activity_pub_dev'

require 'bundler/setup'
require 'activity_pub'

run ActivityPub::Routes
