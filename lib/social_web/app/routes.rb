# frozen_string_literal: true

require 'roda'
require 'slim'
require 'tilt'

module SocialWeb
  class Routes < Roda
    plugin :json
    plugin :hash_routes
    plugin :middleware
    plugin :module_include
    plugin :render,
      engine: 'html.slim',
      views: 'lib/social_web/app/views/'
    plugin :type_routing

    require 'social_web/app/routes/helpers/request_helpers'
    request_module Helpers::RequestHelpers

    require 'social_web/app/routes/inbox'
    require 'social_web/app/routes/outbox'
    require 'social_web/app/routes/well_known'

    route do |r|
      r.verify_signature if r.post?

      r.hash_routes
    end
  end
end
