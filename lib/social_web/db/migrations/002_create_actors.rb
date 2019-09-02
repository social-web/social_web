# frozen_string_literal: true

# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:social_web_actors) do
      primary_key :id

      String :iri, null: false

      Time :created_at, null: false
      Time :updated_at, null: true

      index :iri, unique: true
    end

    alter_table(:social_web_activities) do
      add_foreign_key :actor_iri, :social_web_actors, key: :iri, type: String
    end
  end
end
