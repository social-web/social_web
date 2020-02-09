# frozen_string_literal: true

require 'spec_helper'

module SocialWeb
  module Collections
    RSpec.describe Inbox do
      describe '#process' do
        describe 'Create activity' do
          it "adds the activity to the actor's" do
            actor = create :object, type: 'Actor'

            activity_actor = create :object, type: 'Actor'
            create_act = build :object, type: 'Create', actor: activity_actor

            collection = described_class.for_actor(actor)

            expect(collection).not_to include(create_act)
            expect { collection.process(create_act) }.
              to change { SocialWeb['repositories.objects'].total }.by(+1)
            expect(collection).to include(create_act)
          end
        end

        describe 'Update activity' do
          it 'updates the activity' do
            actor = create :object, type: 'Actor'

            old_content = 'Beep'
            existing_obj = create :object, content: old_content

            activity_actor = create :object, type: 'Actor'
            new_content = 'Boop'
            activity_object = create :object,
              content: new_content,
              id: existing_obj[:id]
            update_act = build :object,
              type: 'Update',
              object: activity_object

            collection = described_class.for_actor(actor)

            expect(collection).not_to include(update_act)
            expect { collection.process(update_act) }.
              to change {
                updated = SocialWeb['repositories.objects'].
                  get_by_iri(existing_obj[:id])
                updated[:content]
              }.from(old_content).to(new_content)
            expect(collection).to include(update_act)
          end
        end
      end
    end
  end
end
