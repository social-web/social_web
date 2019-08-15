# frozen_string_literal: true

%w[
  activity_pub
  activity_streams
  webmention
  well_known
].each do |lib|
  relative_lib_path = File.join(__dir__, lib, 'lib')
  absolute_lib_path = File.expand_path(relative_lib_path)
  unless $:.include?(absolute_lib_path) || $:.include?(relative_lib_path)
    $:.unshift(relative_lib_path)
  end

  require lib
end

require 'roda'

require 'social_web/exceptions'
require 'social_web/configuration'
require 'social_web/hooks'
require 'social_web/routes'

module SocialWeb
  def self.new(app, *args, &block)
    Routes.new(app, *args, &block)
  end

  def self.call(env)
    Routes.call(env)
  end
end
