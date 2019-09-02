# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:social_web_objects) do
      primary_key :id

      String :iri, null: false
      String :type, null: false

      Time :created_at, null: false
      Time :updated_at, null: true

      index :iri, unique: true
    end

    create_table(:social_web_activities) do
      primary_key :id

      String :iri, null: false
      String :type, null: false
      String :collection, null: false
      String :json, null: false

      Time :created_at, null: false
      Time :updated_at, null: true

      index :iri, unique: true
    end

    create_table(:social_web_object_activities) do
      primary_key :id

      foreign_key :social_web_object_id, :social_web_objects
      foreign_key :social_web_activity_id, :social_web_activities

      Time :created_at, null: false
      Time :updated_at, null: true

      index %i[social_web_object_id social_web_activity_id], unique: true
    end
  end
end
