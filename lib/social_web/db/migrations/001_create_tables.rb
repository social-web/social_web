# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:social_web_actors) do
      primary_key :id

      String :iri, null: false
      String :json, null: false

      Time :created_at, null: false
      Time :updated_at, null: true

      index :iri, unique: true
    end

    create_table(:social_web_activities) do
      primary_key :id

      String :iri, null: false
      String :type, null: false
      String :json, null: false

      Time :created_at, null: false
      Time :updated_at, null: true

      index :iri, unique: true
    end

    create_table(:social_web_actor_activities) do
      primary_key :id

      foreign_key :social_web_actor_iri,
        :social_web_actors,
        key: :iri,
        type: String
      foreign_key :social_web_activity_iri,
        :social_web_activities,
        key: :iri,
        type: String

      Time :created_at, null: false
      Time :updated_at, null: true

      index %i[social_web_actor_iri social_web_activity_iri], unique: true
    end

    create_table(:social_web_actor_actors) do
      primary_key :id

      String :collection, null: false

      foreign_key :social_web_actor_iri,
        :social_web_actors,
        key: :iri,
        type: String
      foreign_key :social_web_for_actor_iri,
        :social_web_actors,
        key: :iri,
        type: String

      Time :created_at, null: false
      Time :updated_at, null: true

      index %i[social_web_actor_iri social_web_for_actor_iri], unique: true
    end
  end
end
