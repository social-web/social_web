# frozen_string_literal: true

module SocialWeb
  module Web
    class Routes
      class WellKnown < Roda
        plugin :halt

        route do |r|
          r.on 'webfinger' do
            r.get do
              r.halt 404 unless r.params['resource']&.include?('shane@shanecav.net')
              SocialWeb::Web.config.webfinger_resource
            end
          end
        end
      end
    end
  end
end
