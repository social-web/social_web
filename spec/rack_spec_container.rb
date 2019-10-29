# frozen_string_literal: true

require 'dry/system/container'

class RackSpecContainer < Dry::System::Container
  register(:dereference) do
    dereference = Object.new
    def dereference.call(iri)
      object = OpenStruct.new
      object.inbox = "#{iri}/inbox"
      object
    end
    dereference
  end

  boot :social_web_rack do
    init do
      require 'social_web/rack'
    end

    start do
      SocialWeb::Rack.start!
    end
  end
end

RackSpecContainer.init :social_web_rack
::SocialWeb::Rack::Container.merge(RackSpecContainer)
RackSpecContainer.start :social_web_rack
