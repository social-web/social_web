# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Actors < ROM::Repository[:actors]
        def by_iri(iri)
          actors.by_iri(iri)
        end
      end
    end
  end
end
