# frozen_string_literal: true

module SocialWeb
  module Rack
    module Models
      class Actor < Sequel::Model(SocialWeb::Rack.db[:social_web_objects].where(type: ['Actor']))

        def initialize(iri)
          @iri = iri
        end

        def inbox
          deleted = objects.select(Sequel[:child_iri].as(:iri)).
            association_join(:children).
            where(Sequel[:social_web_objects][:type] => 'Delete').
            where(Sequel[:social_web_relationships][:type] => 'object')
          replies = objects.select(Sequel[:parent_iri].as(:iri)).
            association_join(:children).
            where(Sequel[:social_web_relationships][:type] => 'inReplyTo')

          items = objects.
            join(
              :social_web_collections,
              actor_iri: @iri,
              object_iri: Sequel[:social_web_objects][:iri],
              type: 'inbox'
            ).
            where(Sequel[:social_web_objects][:type] => 'Create').
            exclude(Sequel[:social_web_objects][:iri] => deleted).
            exclude(Sequel[:social_web_objects][:iri] => replies).
            order(Sequel.desc(Sequel[:social_web_objects][:created_at]))

          ActivityStreams.ordered_collection(
            items: items.map do |item|
              obj = ActivityStreams.from_json(item[:json])
              SocialWeb['objects_repo'].reconstitute(obj)
              obj
            end
          )
        end

        private

        def objects
          SocialWeb['objects_rel']
        end
      end
    end
  end
end
