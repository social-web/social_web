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
              {
                'subject': 'acct:shane@shanecav.net',
                'links': [
                  {
                    'rel': 'self',
                    'type': 'application/activity+json',
                    'href': 'https://shanecav.net'
                  },
                  {
                    'rel': 'http://webfinger.net/rel/avatar',
                    'href': 'https://shanecav.net/images/shane_cavanaugh.jpg'
                  },
                  {
                    'rel': 'http://webfinger.net/rel/profile-page',
                    'href': 'https://shanecav.net/'
                  },
                  { 'rel': 'me', 'href': 'https://shanecav.net/' }
                ]
              }
            end
          end
        end
      end
    end
  end
end
