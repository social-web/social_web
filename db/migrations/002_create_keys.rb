# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:social_web_keys) do
      primary_key :id

      String :actor_iri, null: false
      String :private, null: false
      String :public, null: false

      Time :created_at, null: false
      Time :updated_at, null: true

      index :actor_iri, unique: true
      foreign_key :actor_iri, :social_web_actors, key: :iri
    end
  end
end
