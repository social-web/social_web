# frozen_string_literal: true

SocialWeb::Rack::Container.boot :logging do
  start do
    if SocialWeb::Rack.config.logger
      logger = Logger.new(STDOUT)

      require 'social_web/rack/routes'
      SocialWeb::Rack::Routes.plugin :common_logger, logger
    end
  end
end
