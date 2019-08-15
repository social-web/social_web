# frozen_string_literal: true

module ActivityPub
  def self.add_hook(name, &blk)
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
      rescue StandardError => e
        raise FailedHook.new(name, hook.source_location, e)
      end
    end

    class Registry
      attr_accessor :hooks

      def self.instance
        @instance ||= new
      end

      def [](name)
        @hooks[name]
      end

      def register(name, &action)
        @hooks[name] ||= []
        @hooks[name] << action
      end

      private

      def initialize
        @hooks = {}
      end
    end
  end
end
