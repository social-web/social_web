# frozen_string_literal: true

require 'social_web/collections/outbox.rb'
require 'social_web/collections/inbox.rb'
require 'social_web/collections/followers.rb'
require 'social_web/collections/following.rb'
require 'social_web/collections/liked.rb'
require 'social_web/collections/likes.rb'

module SocialWeb
  class Container
    extend Dry::Container::Mixin

    register(:inbox) { Inbox }
    register(:outbox) { Outbox }
    register(:followers) { Followers }
    register(:following) { Following }
    register(:liked) { Liked }
    register(:likes) { Likes }

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
        register(:create) { Inbox::Create.new }
      end

      namespace(:outbox) do
        register(:follow) { Outbox::Follow.new }
      end
    end
  end
end
