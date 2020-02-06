# frozen_string_literal: true

module SocialWeb
  module Models
    class Actor
      def initialize(iri)
        @iri = iri
      end

      def inbox
        collection('inbox')
      end

      def timeline
        deleted = objects.select(Sequel[:social_web_objects][:iri]).
          association_join(
            Sequel[:children].as(:deleted_objects) =>
              Sequel[:parents].as(:delete_activities)
          ).
          where(Sequel[:social_web_relationships][:type] => 'object'). # filter deleted_objects
          where(Sequel[:social_web_relationships_0][:type] => 'object'). # filter delete_activities
          where(Sequel[:social_web_objects][:type] => 'Create').
          where(Sequel[:delete_activities][:type] => 'Delete')

        replies = objects.select(Sequel[:reply_activities][:iri]).
          association_join(
            Sequel[:parents].as(:reply_objects) =>
              Sequel[:parents].as(:reply_activities)
          ).
          where(Sequel[:social_web_relationships][:type] => 'inReplyTo'). # filter reply_objects
          where(Sequel[:social_web_relationships_0][:type] => 'object'). # filter reply_activities
          where(Sequel[:reply_activities][:type] => 'Create')

        items = objects.
          join(
            :social_web_collections,
            actor_iri: @iri,
            object_iri: Sequel[:social_web_objects][:iri],
            type: 'inbox'
          ).
          where(Sequel[:social_web_objects][:type] => %w[Announce Create]).
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

      def collection(type)
        items = objects.
          join(
            :social_web_collections,
            actor_iri: @iri,
            object_iri: Sequel[:social_web_objects][:iri],
            type: type
          ).
          order(Sequel.desc(Sequel[:social_web_objects][:created_at]))

        ActivityStreams.ordered_collection(
          items: items.map do |item|
            obj = ActivityStreams.from_json(item[:json])
            SocialWeb['objects_repo'].reconstitute(obj)
            obj
          end
        )
      end

      def objects
        SocialWeb['objects_rel']
      end
    end
  end
end
