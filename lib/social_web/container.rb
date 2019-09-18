# frozen_string_literal: true

module SocialWeb
  class Container
    extend Dry::Container::Mixin

    register(:http_client)

    namespace(:repositories) do
      register(:activities) {}
    end

    namespace(:services) do
      register(:delivery) {}
      register(:dereference) {}
    end
  end
end
