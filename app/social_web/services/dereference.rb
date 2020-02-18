# frozen_string_literal: true

module SocialWeb
  module Services
    # Retrieve the authoritative object and its nested, authorative associations.
    class Dereference
      PROPERTIES = %i[actor attributedTo inReplyTo object target tag].freeze
      COLLECTIONS = %i[replies].freeze

      def self.for_actor(actor)
        new(actor)
      end

      def initialize(actor)
        @actor = actor
      end

      # Wire the remote storage client with the local storage client on behalf
      # of an actor to remotely access and locally store the object.
      #
      # @param [ActivityStreams::Object] obj
      # @return [ActivityStreams::Object]
      def call(obj)
        obj.traverse_properties(depth: SocialWeb[:config].max_depth) do |hash|
          parent, child, prop = hash.values_at(:parent, :child, :property)

          child = dereference_uri(child) if is_a_uri?(child)
          next unless child.is_a?(ActivityStreams::Object)

          if child.is_a?(ActivityStreams::Collection)
            dereference_collection(parent, child, prop)
          else
            # Store the parent, child, and a record of their relationship
            store_object(child)
            store_relationship(parent, child, prop)
          end

          child
        end

        obj
      end

      private

      def dereference_collection(actor, collection, collection_name)
        collection.traverse_items(depth: 1) do |collection|
          collection[:items] = collection[:items].map do |item|
            item = dereference_uri(item) if is_a_uri?(item)

            store_object(item)
            store_item_in_collection_for_actor(item, collection_name, actor)

            item
          end

          collection
        end
      end

      def dereference_uri(uri)
        SocialWeb['services.http_client'].for_actor(@actor).get(uri)
      end

      def is_a_uri?(child)
        child.is_a?(String) && child.match?(URI.regexp)
      end

      def store_item_in_collection_for_actor(item, collection, actor)
        SocialWeb['repositories.collections'].
          store_object_in_collection_for_actor(
            object: item,
            collection: collection,
            actor: actor
          )
      end

      def store_object(obj)
        SocialWeb['repositories.objects'].store(obj)
      end

      def store_relationship(parent, child, prop)
        SocialWeb['repositories.relationships'].store(
          parent: parent,
          child: child,
          property: prop
        )
      end
    end
  end
end
