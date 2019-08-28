# frozen_string_literal: true

module SocialWeb
  module Respositories
    def self.all
      items = dataset.
        order(Sequel.desc(:created_at)).
        map { |o| ActivityStreams.from_json(o.json) }
      ActivityStreams::Collection::OrderedCollection.new(items: items)
    end
  end
end
