# frozen_string_literal: true

require_relative './concerns/normalize_id'

module SocialWeb
  module Relations
    class Keys < Sequel::Model(SocialWeb[:db][:social_web_keys])
      include NormalizeID

      dataset_module do
        def by_object_iri(iri)
          where(object_iri: normalize_id(iri))
        end
      end
    end
  end
end
