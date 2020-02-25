# frozen_string_literal: true

module SocialWeb
  module Services
    # Retrieve the authoritative object and its nested, authorative associations.
    class Dereference
      # Don't dereference these properties
      IGNORED_PROPERTIES = %i[@context id].freeze

      def self.for_actor(actor)
        new(actor)
      end

      def initialize(actor)
        @actor = actor
      end

      # Wire the remote storage client with the local storage client on behalf
      # of an actor to remotely access and locally store the object and its children.
      #
      # @param [ActivityStreams::Object] obj
      # @return [ActivityStreams::Object]
      def call(obj)
        unless obj.is_a?(ActivityStreams)
          raise "Expected an ActivityStreams object, got: #{obj.class}"
        end

        obj_dup = obj.dup

        obj_dup.traverse_properties(depth: SocialWeb[:config].max_depth) do |hash|
          parent, child, prop = hash.values_at(:parent, :child, :property)
          next if IGNORED_PROPERTIES.include?(prop)

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

        obj_dup
      end

      private

      def dereference_collection(actor, collection, collection_name)
        collection.traverse_items(depth: SocialWeb[:config].max_depth) do |collection|
          collection = dereference_uri(collection) if is_a_uri?(collection)\

          if collection.is_a?(ActivityStreams::OrderedCollection)
            collection[:orderedItems] ||= []
            collection[:orderedItems] = collection[:orderedItems].map do |i|
              dereference_collection_item(i, collection_name, actor)
            end
          elsif collection.is_a?(ActivityStreams::Collection)
            collection[:items] ||= []
            collection[:items] = collection[:items].map do |i|
              dereference_collection_item(i, collection_name, actor)
            end
          end

          collection
        end
      end

      def dereference_collection_item(item, collection_name, actor)
        item = dereference_uri(item) if is_a_uri?(item)
        item = ActivityStreams.new(**item) if item.is_a?(Hash)

        store_object(item)
        store_item_in_collection_for_actor(item, collection_name, actor)

        item
      end

      def dereference_uri(uri)
        http_client.get(uri)
      end

      def http_client
        @http_client ||= SocialWeb['services.http_client'].for_actor(@actor)
      end

      def is_a_uri?(child)
        child.is_a?(String) && child.match?(/^#{URI.regexp}$/)
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
