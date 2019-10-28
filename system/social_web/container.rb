# frozen_string_literal: true

require 'dry/system/container'

module SocialWeb
  def self.[](key)
    container[key]
  end

  def self.container
    @container ||= Container.merge(SocialWeb.config.container)
  end

  class Container < Dry::System::Container
    configure do |config|
      config.auto_register = 'lib'
      config.default_namespace = 'social_web'
    end

    load_paths! 'lib'

    # Repositories
    register(:activities) { }
    register(:actors) { }
    register(:objects) { }

    # Services
    register(:delivery) {}
    register(:dereference) {}

    # Collections
    register(:inbox) { Inbox }
    register(:outbox) { Outbox }

    register(:followers) { Followers }
    register(:following) { Following }

    register(:liked) { Liked }
    register(:likes) { Likes }
  end
end
