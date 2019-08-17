# frozen_string_literal: true

require 'bundler/setup'

require 'roda'

require 'well_known/exceptions'
require 'well_known/configuration'
require 'well_known/hooks'

module WellKnown
  def self.configure
    yield config
  end

  def self.config
    @configuration ||= Configuration.new
  end

  class Routes < ::Roda
    plugin :halt
    plugin :json
    plugin :json_parser
    plugin :middleware, env_var: 'social_web.well_known'

    route do |r|
      r.on('.well-known') do
        r.get 'webfinger' do
          Hooks.run('webfinger.get.before', request: r)

          resource_param = r.params['resource']
          r.halt 400 if resource_param.nil?
          if WellKnown.config.webfinger_resource[:subject] != resource_param
            r.halt 404
          end

          response.status = 200
          response['Content-Type'] = 'application/jrd+json'
          WellKnown.config.webfinger_resource
        ensure
          Hooks.run('webfinger.get.after', response: response, request: r)
        end
      end
    end
  end
end
