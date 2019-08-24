# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:activity_pub_objects) do
      primary_key :id
      String :source, null: false
      Time :created_at, null: false
      Time :updated_at, null: true
      String :collection, null: false
    end

    add_index :activity_pub_objects, [:collection, :source], unique: true
  end
end
