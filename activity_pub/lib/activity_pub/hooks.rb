# frozen_string_literal: true

require 'dry-events'
require 'singleton'

module ActivityPub
  def self.add_hook(name, &blk)
    Hooks.instance.subscribe(name, &blk)
  end

  class Hooks
    include ::Singleton
    include Dry::Events::Publisher[:activity_pub]

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
