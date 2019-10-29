# frozen_string_literal: true

require 'dry/system/container'

module SocialWeb
  module Rack
    class Container < Dry::System::Container
      configure do |config|
        config.system_dir = Pathname('./system/social_web/rack')
      end

      load_paths! 'apps/social_web/rack'

      require 'social_web/rack/configuration'
      require 'social_web/rack/routes'

      require 'social_web/rack/collections/following'
      register(:following) { Collections::Following }

      # Repositories
      require 'social_web/rack/repositories'
      register(:activities) { Repositories::Activities.new }
      register(:actors) { Repositories::Actors.new }
      register(:keys) { Repositories::Keys.new }

      # Services
      require 'social_web/rack/services'
      register(:delivery) { Rack::Delivery.new }
      register(:dereference) { Rack::Dereference }
    end
  end
end
