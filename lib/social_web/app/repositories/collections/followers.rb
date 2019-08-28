# frozen_string_literal: true

module SocialWeb
  class Followers < Sequel::Model(Activities.where(collection: 'followers')); end
end
