# frozen_string_literal: true

module SocialWeb
  module Collections
    class Outbox < SocialWeb::Collection
      TYPE = 'Outbox'

      def process(activity); end
    end
  end
end
