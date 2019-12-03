# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:social_web_objects) do
      primary_key :id

      String :iri, null: false
      index :iri, unique: true

      String :json, null: false

      String :type, null: false
      index :type

      Time :created_at, null: false
      Time :updated_at, null: true
    end

    create_table(:social_web_relationships) do
      primary_key :id

      String :parent_iri, null: false
      String :child_iri, null: false

      String :type, null: false

      Time :created_at, null: false
      Time :updated_at, null: true

      index %i[child_iri parent_iri type], unique: true
    end

    create_table(:social_web_collections) do
      primary_key :id

      String :type, null: false
      foreign_key :actor_iri,
        :social_web_objects,
        key: :iri,
        on_delete: :cascade,
        on_update: :cascade,
        type: String
      foreign_key :object_iri,
        :social_web_objects,
        key: :iri,
        on_delete: :cascade,
        on_update: :cascade,
        type: String

      Time :created_at, null: false
      Time :updated_at, null: true

      index %i[type actor_iri object_iri], unique: true
    end
  end
end
