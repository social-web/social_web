# frozen_string_literal: true

module SocialWeb
  def self.configure
    yield config

    config.activity_pub
    config.webmention
    config.well_known
  end

  def self.config
    @configuration ||= Configuration.new
  end

  class Configuration
    attr_accessor :activity_pub,
      :webmention,
      :well_known

    def activity_pub
      return @activity_pub if @activity_pub == false

      @activity_pub ||= begin
        require 'social_web/activity_pub'
        ActivityPub.config
      end
    end

    def activity_pub=(value)
      @activity_pub = value == false ? false : activity_pub
    end

    def webmention
      return @webmention if @webmention == false

      @webmention ||= begin
        require 'social_web/webmention'
        Webmention.config
      end
    end

    def webmention=(value)
      @webmention = value == false ? false : webmention
    end

    def well_known
      return @well_known if @well_known == false

      @well_known ||= begin
        require 'social_web/well_known'
        WellKnown.config
      end
    end

    def well_known=(value)
      @well_known = value == false ? false : well_known
    end
  end
end
