# frozen_string_literal: true

module SocialWeb
  # A collection is a domain-level repo intended to be used by domain models
  # for storage access
  class Collection
    def self.for_actor(actor)
      new(actor)
    end

    def initialize(for_actor)
      @actor = for_actor
    end

    def add(obj)
      SocialWeb['objects_repo'].store(obj)
      SocialWeb['collections_repo'].
        store_object_in_collection_for_iri(
          object: obj,
          collection: self::TYPE,
          actor: actor
        )
      true
    end

    def includes?(obj)
      SocialWeb['repositories.collections'].stored?(
        object: obj,
        collection: self.class::TYPE.downcase,
        actor: actor
      )
    end

    private

    attr_reader :actor

    def store_obj_in_collection(obj, collection)
      SocialWeb['objects_repo'].store(obj)
      SocialWeb['collections_repo'].
        store_object_in_collection_for_iri(
          object: obj,
          collection: self::TYPE,
          actor: actor
        )
      true
    end
  end
end
