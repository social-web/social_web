# frozen_string_literal: true

require 'bundler/setup'

require 'roda'

require 'webmention/configuration'

module Webmention
  def self.configure
    yield config
  end

  def self.config
    @configuration ||= Configuration.new
  end

  class Route < ::Roda
    plugin :json_parser
    plugin :middleware, env_var: 'social_web.webmention'

    route do |r|
      r.on('webmentions') do
        r.post do
          webmention_params = r.params.
            slice('source', 'target').
            reject { |_k, v| v.empty? }

          if webmention_params.count != 2
            response.status = 400
            return ''
          end

          response.status = 201
          ''
        end
      end
    end
  end
end
