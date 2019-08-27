# frozen_string_literal: true

require 'roda'

module SocialWeb
  class Routes < Roda
    plugin :json
    plugin :hash_routes
    plugin :middleware

    require 'social_web/app/routes/inbox'
    require 'social_web/app/routes/well_known'

    route do |r|
      r.hash_routes
    end
  end
end
