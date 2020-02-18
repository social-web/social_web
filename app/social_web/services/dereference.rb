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
        new_obj.traverse_properties(depth: SocialWeb[:config].max_depth) do |hash|
          parent, child, prop = hash.values_at(:parent, :child, :property)

          if child.is_a?(String) && child.match?(URI.regexp)
            child = SocialWeb['services.http_client'].for_actor(@actor).get(child)
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
    end
  end
end
