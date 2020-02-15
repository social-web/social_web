# frozen_string_literal: true

require_relative '../social_web'
require 'social_web/container'

SocialWeb::Container.load_paths
SocialWeb::Container.start :tasks
SocialWeb::Container.start :logging
SocialWeb::Container.start :configuration
