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
      end

      namespace(:services) do
        register(:delivery) { ->(act) { puts "SocialWeb: Delivered #{act}" } }
      end
    end
  end
end
