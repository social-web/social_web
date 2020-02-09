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
        new_obj = obj.dup
        new_obj.traverse_properties(PROPERTIES, depth: SocialWeb[:config].max_depth) do |hash|
          parent, child, prop = hash.values_at(:parent, :child, :property)

          # Check if the value of `child` is a remotely accessible IRI
          if child.is_a?(String) && child.match?(URI.regexp)
            child = SocialWeb['repositories.objects'].get_by_iri(child) ||
              SocialWeb['services.http_client'].
                # We'll need to sign the request on the actor's behalf
                for_actor(actor).
                # Retrieve the remote object
                get(child)
          end

          # Store the parent, child, and a record of their relationship
          if child.is_a?(ActivityStreams::Object)
            SocialWeb['repositories.objects'].store(child)
            SocialWeb['repositories.relationships'].store(
              parent: parent,
              child: child,
              property: prop
            )
          end

          child
        end

        new_obj
      end

      private

      attr_reader :actor
    end
  end
end
