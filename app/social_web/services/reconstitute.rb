# frozen_string_literal: true

module SocialWeb
  module Services
    # Retrieve and assign object's nested relationships
    class Reconstitute
      def call(obj)
        SocialWeb['repositories.objects'].traverse(obj) do |prop_map|
          parent, child, prop = prop_map.values_at(:parent, :child, :property)
          parent[prop] = child

          # Add replies to child's replies and also to given object's replies
          if prop == 'inReplyTo'
            child[:replies][:items] ||= []
            child[:replies][:items] << parent

            if obj[:replies]
              obj[:replies][:items] ||= []
              obj[:replies][:items] << parent
            end
          end
        end
      end
    end
  end
end
