# frozen_string_literal: true

module SocialWeb
  module Rack
    module Relations
      class Objects < ROM::Relation[:sql]
        schema(:social_web_objects, as: :objects, infer: true) do
          attribute :iri, Types::String
          primary_key :iri

          associations do
            has_many :objects,
              as: :collection_items,
              foreign_key: :actor_iri,
              through: :collections
            has_many :objects,
              as: :parents,
              view: :parents,
              foreign_key: :iri,
              combine_keys: { iri: :child_iri },
              override: true
            has_many :objects,
              as: :children,
              view: :children,
              foreign_key: :iri,
              combine_keys: { iri: :parent_iri },
              override: true
          end
        end

        def children(_assoc, objects)
          ds = dataset.
            select_append(
              Sequel[:social_web_relationships][:parent_iri],
              Sequel[:social_web_relationships][:type].as(:rel_type)
            ).
            join(:social_web_relationships, child_iri: :iri).
            where(parent_iri: objects.map { |o| o[:iri] }.uniq)

          new(ds)
        end

        def insert(**kwargs)
          vals = kwargs.slice(:iri, :type, :json)

          SocialWeb::Rack.db[:social_web_objects].insert(
            iri: vals[:iri],
            type: vals[:iri],
            json: vals[:json],
            created_at: Time.now.utc
          )
        end

        def parents(_assoc, objects)
          ds = dataset.
            select_append(
              Sequel[:social_web_relationships][:child_iri],
              Sequel[:social_web_relationships][:type].as(:rel_type)
            ).
            join(:social_web_relationships, parent_iri: :iri).
            where(child_iri: objects.map { |o| o[:iri] }.uniq)

          new(ds)
        end

        def by_collection(type)
          ds = dataset.dataset.joins(:inner, )
        end

        def by_iri(iri)
          where(iri: iri)
        end

        def exclude_by_type(type)
          exclude(type: type)
        end

        def relationships(_assoc, objects)
          relations[:social_web_relationships].
            where(parent_iri: objects.map(:iri)).
            or(child_iri: objects.map(:iri))
        end

        def traverse
          dataset.dataset.db[:threads].
            with_recursive(
              :threads,
              dataset.dataset.db[:social_web_objects].
                select(
                  Sequel[:social_web_objects][:iri],
                  Sequel[:parents][:iri],
                  Sequel[:parents][:json],
                  Sequel[:social_web_relationships][:type],
                  Sequel[:social_web_objects][:created_at]
                ) { 1 }.
                join(:social_web_relationships, { child_iri: :iri }).
                join(Sequel[:social_web_objects].as(:parents), { iri: :parent_iri }),

              dataset.dataset.db[:social_web_objects].
                select(
                  Sequel[:social_web_objects][:iri],
                  Sequel[:parents][:iri],
                  Sequel[:parents][:json],
                  Sequel[:social_web_relationships][:type],
                  Sequel[:social_web_objects][:created_at]
                ) { Sequel[:_depth] + 1 }.
                join(:social_web_relationships, { child_iri: :iri }).
                join(Sequel[:social_web_objects].as(:parents), { iri: :parent_iri }).
                join(:threads, Sequel[:threads][:parent_iri] => Sequel[:social_web_objects][:iri]).
                where { Sequel[:_depth] <= 100 },

              args: [:child_iri, :parent_iri, :child_json, :rel_type, :created_at, :_depth],
              union_all: false
            )
        end
      end
    end
  end
end
