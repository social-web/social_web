# frozen_string_literal: true

SocialWeb::Container.boot :routes do
  init do
    require 'roda'
    require 'social_web/routes'

    register(:routes, SocialWeb::Routes)
  end
end
