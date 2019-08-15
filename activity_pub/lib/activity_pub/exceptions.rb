# frozen_string_literal: true

module ActivityPub
  class Error < StandardError; end
  class FailedHook < Error
    MESSAGE_FORMAT = <<~TXT
        %<hook_name>s: %<hook_source_location>s

        %<exception_class>s: %<exception_message>s
    TXT
    attr_accessor :hook_name, :hook_source_location, :wrapped_exception

    def initialize(hook_name, hook_source_location, wrapped_exception)
      @hook_name = hook_name
      @hook_source_location = hook_source_location
      @wrapped_exception = wrapped_exception
      super(format_message)
    end

    def cause
      wrapped_exception || super
    end

    private

    def format_message
      format(
        MESSAGE_FORMAT,
        hook_name: hook_name,
        exception_class: wrapped_exception.class,
        exception_message: wrapped_exception.message,
        hook_source_location: hook_source_location.join(':')
      )
    end
  end
end
