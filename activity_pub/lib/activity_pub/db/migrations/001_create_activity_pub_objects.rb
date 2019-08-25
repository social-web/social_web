# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:activity_pub_objects) do
      primary_key :id
      String :uri, null: false
      String :json, null: false
      Time :created_at, null: false
      Time :updated_at, null: true

      index :uri, unique: true
    end

    create_table(:activity_pub_activities) do
      primary_key :id
      String :uri, null: false
      String :json, null: false
      Time :created_at, null: false
      Time :updated_at, null: true
      String :collection, null: false

      index :uri, unique: true
      foreign_key :activity_pub_object_id, :activity_pub_objects
      index :activity_pub_object_id
      index [:collection, :json], unique: true
    end
  end
end
