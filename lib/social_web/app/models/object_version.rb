# frozen_string_literal: true

module SocialWeb
  class ObjectVersion < Sequel::Model(SocialWeb.db[:social_web_object_versions])
    def activity=(act)
      self.social_web_activity_id = act.id
    end

    def object=(obj)
      self.social_web_object_id = obj.id
    end
  end
end
