# frozen_string_literal: true

module SocialWeb
  module Services
    class Delivery
      def self.call(inbox, activity)
        HTTP.post(inbox, json: activity.to_json)
      end
    end
  end
end
