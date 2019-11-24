# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:social_web_keys) do
      primary_key :id

      String :private, null: false
      String :public, null: false

      Time :created_at, null: false
      Time :updated_at, null: true

      foreign_key :object_iri,
        :social_web_objects,
        key: :iri,
        type: String,
        on_delete: :cascade,
        on_update: :cascade
      index :object_iri, unique: true
    end
  end
end
