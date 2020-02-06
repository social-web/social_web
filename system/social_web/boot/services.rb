# frozen_string_literal: true

SocialWeb::Container.boot :services do
  init do

    require 'social_web/services/dereference'
    register('services.dereference', SocialWeb::Services::Dereference)

    require 'social_web/services/http_client'
    register('services.http_client', SocialWeb::Services::HTTPClient)

    require 'social_web/services/reconstitute'
    register('services.reconstitute', SocialWeb::Services::Reconstitute.new)
  end
end
