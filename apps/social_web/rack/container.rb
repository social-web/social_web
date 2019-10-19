# frozen_string_literal: true

require 'dry-container'

module SocialWeb
  module Rack
    class Container
      extend Dry::Container::Mixin

      namespace(:collections) do
        register(:following) { Collections::Following.new }
      end

      namespace(:repositories) do
        register(:activities) { Repositories::Activities.new }
        register(:actors) { Repositories::Actors.new }
        register(:keys) { Repositories::Keys.new }
      end

      namespace(:services) do
        register(:delivery) { Rack::Delivery.new }
        register(:dereference) { Rack::Dereference.new }
      end
    end
  end
end
