# frozen_string_literal: true

require 'dry/system/container'

class RackSpecContainer < Dry::System::Container
  register(:dereference) do
    dereference = Object.new
    def dereference.call(iri)
      SocialWeb::Rack['actors'].get_by_iri(iri) ||
        SocialWeb::Rack['activities'].get_by_iri(iri) ||
        begin
          obj = OpenStruct.new
          obj.id = iri
          obj.type = 'Some Type'
          obj
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
