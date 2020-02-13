# frozen_string_literal: true

module SocialWeb
  class Logger < ::Logger
    FORMATTER = lambda do |severity, datetime, progname, msg|
      ::Logger::Formatter.new.call(severity, datetime, 'SocialWeb', msg)
    end
    LOG_LEVELS = [:debug , :info , :warn , :error , :fatal , :unknown]

    def initialize(*ios)
      @loggers = ios.map { |io| ::Logger.new(io, formatter: FORMATTER) }
    end

    LOG_LEVELS.each do |log_level|
      define_method(log_level) do |message|
        @loggers.each { |logger| logger.send(log_level, message) }
      end
    end

    alias_method :<<, :info
    alias_method :write, :info
  end
end
