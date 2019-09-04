# frozen_string_literal: true

module Helpers
  module Request
    def app
      SocialWeb::Routes.app
    end

    def login_as(actor)
      user = double('user', actor: actor)
      warden = double('warden', authenticate: true, user: user)
      env('warden', warden)
    end
  end
end
