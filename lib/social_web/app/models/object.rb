# frozen_string_literal: true

module SocialWeb
  class Object < Sequel::Model(SocialWeb.db[:social_web_objects])
     many_to_many :activities,
       join_table: :social_web_object_versions,
       left_key: :social_web_object_id,
       right_key: :social_web_activity_id
  end
end
