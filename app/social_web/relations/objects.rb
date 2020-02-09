# frozen_string_literal: true

require_relative './concerns/normalize_id'

module SocialWeb
  module Relations
    class Objects < Sequel::Model(SocialWeb[:db][:social_web_objects])
      include NormalizeID

      set_primary_key :iri

      many_to_many :children,
        class: self,
        graph_join_type: :inner,
        join_table: :social_web_relationships,
        left_key: :parent_iri,
        right_key: :child_iri

      many_to_many :parents,
        class: self,
        graph_join_type: :inner,
        join_table: :social_web_relationships,
        left_key: :child_iri,
        right_key: :parent_iri

      class << self
        def by_iri(iri)
          where(iri: iri)
        end

        def by_type(type)
          where(type: type)
        end

        def traverse_children(iri, depth: SocialWeb[:config].max_depth)
          SocialWeb[:db][:threads].
            with_recursive(
              :threads,

              select(
                Sequel[:social_web_objects][:iri],
                Sequel[:children][:iri],
                Sequel[:social_web_objects][:json],
                Sequel[:children][:json],
                Sequel[:social_web_relationships][:type],
                Sequel[:social_web_objects][:created_at]
              ) { 1 }.
                join(:social_web_relationships, { parent_iri: :iri }).
                join(Sequel[:social_web_objects].as(:children), { iri: :child_iri }).
                where(Sequel[:social_web_objects][:iri] => iri),

              select(
                Sequel[:social_web_objects][:iri],
                Sequel[:children][:iri],
                Sequel[:social_web_objects][:json],
                Sequel[:children][:json],
                Sequel[:social_web_relationships][:type],
                Sequel[:social_web_objects][:created_at]
              ) { Sequel[:depth] + 1 }.
                join(:social_web_relationships, { parent_iri: :iri }).
                join(Sequel[:social_web_objects].as(:children), { iri: :child_iri }).
                join(:threads, Sequel[:threads][:child_iri] => Sequel[:social_web_objects][:iri]).
                where { Sequel[:threads][:depth] <= depth },

              args: [:parent_iri, :child_iri, :parent_json, :child_json, :rel_type, :created_at, :depth]
            )
        end

        def traverse_parents(iri, depth: SocialWeb[:config].max_depth)
          SocialWeb[:db][:threads].
            with_recursive(
              :threads,

              select(
                Sequel[:social_web_objects][:iri],
                Sequel[:parents][:iri],
                Sequel[:social_web_objects][:json],
                Sequel[:parents][:json],
                Sequel[:social_web_relationships][:type],
                Sequel[:social_web_objects][:created_at]
              ) { 1 }.
                join(:social_web_relationships, { child_iri: :iri }).
                join(Sequel[:social_web_objects].as(:parents), { iri: :parent_iri }).
                where(Sequel[:social_web_objects][:iri] => iri),

              select(
                Sequel[:social_web_objects][:iri],
                Sequel[:parents][:iri],
                Sequel[:social_web_objects][:json],
                Sequel[:parents][:json],
                Sequel[:social_web_relationships][:type],
                Sequel[:social_web_objects][:created_at]
              ) { Sequel[:depth] + 1 }.
                join(:social_web_relationships, { child_iri: :iri }).
                join(Sequel[:social_web_objects].as(:parents), { iri: :parent_iri }).
                join(:threads, Sequel[:threads][:parent_iri] => Sequel[:social_web_objects][:iri]).
                where { Sequel[:threads][:depth] <= depth },

              args: [:child_iri, :parent_iri, :child_json, :parent_json, :rel_type, :created_at, :depth]
            )
        end
      end
    end
  end
end
