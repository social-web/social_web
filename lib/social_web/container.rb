# frozen_string_literal: true

module SocialWeb
  class Container
    extend Dry::Container::Mixin

    namespace(:repositories) do
      register(:activities) {}
      register(:actors) {}
    end

    namespace(:services) do
      register(:delivery) {}
      register(:dereference) {}
    end

    namespace(:collections) do
      namespace(:inbox) do
        register(:accept) { Inbox::Accept.new }
      end

      namespace(:outbox) do
        register(:follow) { Outbox::Follow.new }
      end
    end
  end
end
