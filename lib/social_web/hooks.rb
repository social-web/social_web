# frozen_string_literal: true

module SocialWeb
  module Hooks
    class FailedHook < SocialWeb::Error
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

    def self.register(name, &action)
      Registry.instance.register(name, &action)
    end

    def self.run(name, *args, **kwargs)
      hook = Registry.instance[name]
      hook&.call(*args, **kwargs)
    rescue StandardError => e
      raise FailedHook.new(name, hook.source_location, e)
    end

    class Registry
      attr_accessor :hooks

      def self.instance
        @instance ||= new
      end

      def initialize
        @hooks = {}
      end

      def [](name)
        @hooks[name]
      end

      def register(name, &action)
        @hooks[name] = action.to_proc
      end
    end
  end
end
