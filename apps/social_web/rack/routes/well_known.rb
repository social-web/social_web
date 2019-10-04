# frozen_string_literal: true

module SocialWeb
  module Rack
    class Routes
      class WellKnown < Roda
        plugin :halt
        plugin :json

        route do |r|
          r.on 'webfinger' do
            r.get do
              r.halt 404 unless r.params['resource']&.include?('shane@shanecav.net')
              SocialWeb::Rack.config.webfinger_resource
            end
          end
        end
      end
    end
  end
end
