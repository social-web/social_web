# frozen_string_literal: true

module SocialWeb
  module App
    class Container
      namespace(:collections) do
        register(:following) { Collections::Following }
      end

      namespace(:repositories) do
        register(:activities) { Repositories::Activities.new }
        register(:actors) { Repositories::Actors.new }
      end
    end
  end
end
