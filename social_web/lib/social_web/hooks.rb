# frozen_string_literal: true

require 'dry-events'
require 'singleton'

module SocialWeb
  def self.add_hook(name, &blk)
    Hooks.instance.subscribe(name, &blk)
  end

  class Hooks
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

    include ::Singleton
    include Dry::Events::Publisher[:social_web]

    def self.[](name)
      instance.process(name)
    end

    def self.register(name)
      instance.register_event(name)
    end

    def self.run(name, **kwargs)
      instance.publish(name, kwargs)
    end
  end
end
