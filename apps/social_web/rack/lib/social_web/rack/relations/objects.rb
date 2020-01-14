# frozen_string_literal: true

module SocialWeb
  module Rack
    module Relations
      class Objects < Sequel::Model(SocialWeb::Rack.db[:social_web_objects])
        set_primary_key :iri

        many_to_many :collections,
          class: self,
          graph_join_type: :inner,
          join_table: :social_web_collections,
          left_key: :actor_iri,
          right_key: :object_iri

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

          def traverse
            dataset[:threads].
              with_recursive(
                :threads,
                dataset[:social_web_objects].
                  select(
                    Sequel[:social_web_objects][:iri],
                    Sequel[:parents][:iri],
                    Sequel[:parents][:json],
                    Sequel[:social_web_relationships][:type],
                    Sequel[:social_web_objects][:created_at]
                  ) { 1 }.
                  join(:social_web_relationships, { child_iri: :iri }).
                  join(Sequel[:social_web_objects].as(:parents), { iri: :parent_iri }),

                dataset[:social_web_objects].
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
end
