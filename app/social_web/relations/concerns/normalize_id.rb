# frozen_string_literal: true

module SocialWeb
  module Relations
    # Provides a callback for normalizing an object's ID before insertion
    module NormalizeID
      def self.included(base)
        base.class_eval do
          unrestrict_primary_key

          def before_create
            each do |k, v|
              if k.to_s.end_with?('iri')
                self[k] = normalize_id(v)
              end
            end
            super
          end

          private

          def normalize_id(id)
            id.end_with?('/') ? id.chop : id
          end
        end
      end
    end
  end
end
