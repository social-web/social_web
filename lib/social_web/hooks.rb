# frozen_string_literal: true

module SocialWeb
  def self.add_hook(name, &hook)
    Hooks::Registry.instance.register(name, &blk)
  end

  module Hooks
    def self.[](name)
      Registry.instance[name]
    end

    def self.run(name, *args, **kwargs)
      hooks = Registry.instance[name]
      hooks&.each do |hook|
        hook.call(*args, **kwargs)
      end
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
