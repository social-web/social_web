# frozen_string_literal: true

module SocialWeb
  module Services
    class Addressing
      include Container['services.dereference']

      ADDRESS_FIELDS = %i[to bto cc bcc audience].freeze

      def call(activity)
        ADDRESS_FIELDS.map do |field|
          activity.public_send(field) if activity.respond_to?(field)
        end.
          reject { |address| ['', nil].include?(address) }.
          map { |address| dereference.call(address) }
      end
    end
  end
end
