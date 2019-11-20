# frozen_string_literal: true

require 'dry/system/container'

class RackSpecContainer < Dry::System::Container
  register(:dereference) do
    dereference = Object.new
    def dereference.call(iri)
      iri = iri.respond_to?(:id) ? iri.id : iri
      SocialWeb::Rack['objects'].get_by_iri(iri) ||
        begin
          ActivityStreams.new {
            id iri
            type 'Some Type'
          }
        end
    end
    dereference
  end

  boot :social_web_rack do
    init do
      require 'social_web/rack'
    end

    start do
      ::SocialWeb::Rack::Container.merge(RackSpecContainer)
      SocialWeb::Rack.start!
    end
  end
end
