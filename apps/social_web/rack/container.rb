# frozen_string_literal: true

require 'dry-container'

module SocialWeb
  module Rack
    class Container
      extend Dry::Container::Mixin

      # Collections
      register(:following) { Collections::Following }

      # Repositories
      register(:activities) { Repositories::Activities.new }
      register(:actors) { Repositories::Actors.new }
      register(:keys) { Repositories::Keys.new }

      # Services
      register(:delivery) { Rack::Delivery.new }
      register(:dereference) { Rack::Dereference }
    end
  end
end
