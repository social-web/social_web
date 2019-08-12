# frozen_string_literal: true

require 'spec_helper'

require 'activity_pub'
require 'activity_streams'
require 'webmention'
require 'well_known'

module SocialWeb
  RSpec.describe Configuration do

    {
      activity_pub: ActivityPub,
      webmention: Webmention,
      well_known: WellKnown
    }.each do |namespace, library|

      context "when configuring #{library}" do
        it "defaults to initializing #{library} and its config" do
          # Reset the class instance variable set in other tests
          SocialWeb.config.instance_variable_set("@#{namespace}".to_sym, nil)

          expect(library).to receive(:config)
          SocialWeb.configure {}
        end

        it "can set ##{namespace} to false" do
          expect(library).not_to receive(:config)
          config = described_class.new
          config.public_send("#{namespace}=", false)
          expect(config.public_send(namespace)).to eq(false)
        end

        it "can set ##{namespace} to an instance of #{library}::Configuration" do
          config = described_class.new
          expect(config.public_send(namespace)).
            to be_an_instance_of(library::Configuration)
        end
      end
    end
  end
end
