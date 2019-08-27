# frozen_string_literal: true

Sequel::Model.plugin :timestamps

require 'social_web/app/models/activity'
require 'social_web/app/models/object'
require 'social_web/app/models/object_version'
