# frozen_string_literal: true

module SocialWeb
  module Rack
    class Addressing
      ADDRESS_FIELDS = %i[to bto cc bcc audience].freeze

      def call(activity)
        ADDRESS_FIELDS.map do |field|
          activity.public_send(field) if activity.respond_to?(field)
        end.
          reject { |address| ['', nil].include?(address) }.
          map { |address| SocialWeb::Rack['objects'].get_by_iri(address) }
      end
    end
  end
end
