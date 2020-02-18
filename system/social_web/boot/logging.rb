# frozen_string_literal: true

SocialWeb::Container.boot :logging do
  init do
    require 'logger'

    SocialWeb::LOG_FORMATTER = lambda do |severity, datetime, progname, msg|
      ::Logger::Formatter.new.call(severity, datetime, 'SocialWeb', msg)
    end

    register(:logger, ::Logger.new(STDOUT, formatter: SocialWeb::LOG_FORMATTER))
  end
end
