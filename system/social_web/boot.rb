# frozen_string_literal: true

require 'social_web/container'

SocialWeb::Container.load_paths
SocialWeb::Container.start :logging
SocialWeb::Container.start :configuration
