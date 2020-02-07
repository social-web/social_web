# frozen_string_literal: true

SocialWeb::Container.boot :activity_pub do
  init do

    require 'social_web/collection'
    container.namespace(:collections) do
      require 'social_web/collections/inbox'
      register(:inbox, SocialWeb::Collections::Inbox)

      require 'social_web/collections/outbox'
      register(:oubox, SocialWeb::Collections::Outbox)

      require 'social_web/collections/following'
      register(:following, SocialWeb::Collections::Following)
    end
  end
end
