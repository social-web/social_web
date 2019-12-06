# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Objects
        DEREFERENCEABLE_PROPS = %i[actor inReplyTo object target tag].freeze

        def stored?(iri)
          !get_from_cache(iri).nil?
        end

        def thread_for_iri(iri, depth: 1)
          SocialWeb::Rack.db.transaction do
            selects = [
            ]

            SocialWeb::Rack.db.run("set statement_timeout to '10s'")
            SocialWeb::Rack.db[:threads].
              with_recursive(
                :threads,
                SocialWeb::Rack.db[:social_web_objects].
                  select(
                    Sequel[:social_web_objects][:iri],
                    Sequel[:children][:iri],
                    Sequel[:children][:json],
                    Sequel[:social_web_relationships][:type],
                    Sequel[:social_web_objects][:created_at]
                  ) { 1 }.
                  join(:social_web_relationships, { child_iri: :iri }).
                  join(Sequel[:social_web_objects].as(:children), { iri: :parent_iri }).
                  where(Sequel[:social_web_relationships][:parent_iri] => iri),

                SocialWeb::Rack.db[:social_web_objects].
                  select(
                    Sequel[:social_web_objects][:iri],
                    Sequel[:children][:iri],
                    Sequel[:children][:json],
                    Sequel[:social_web_relationships][:type],
                    Sequel[:social_web_objects][:created_at]
                  ) { Sequel[:_depth] + 1 }.
                  join(:social_web_relationships, { child_iri: :iri }).
                  join(Sequel[:social_web_objects].as(:children), { iri: :parent_iri }).
                  join(:threads, Sequel[:threads][:child_iri] => Sequel[:social_web_objects][:iri]).
                  where { Sequel[:_depth] <= depth },

                args: [:parent_iri, :child_iri, :child_json, :rel_type, :created_at, :_depth],
                union_all: false
              )
          end
        end

        def get_by_iri(iri)
          found = get_from_cache(iri) || get_fresh(iri)
          return unless found

          SocialWeb::Rack['traverse'].call(found) do |parent, rel, child|
            parent.public_send("#{rel}=", child)
          end

          found
        end

        def store(obj)
          SocialWeb::Rack.db.transaction do
            insert_object(obj)

            SocialWeb::Rack['traverse'].call(obj) do |parent, rel, child|
              insert_object(parent)
              SocialWeb['relationships'].store(parent: parent, prop: rel, child: child)
            end
          end
        end

        private

        attr_accessor :loop_count

        def get_from_cache(iri)
          found = SocialWeb::Rack.db[:social_web_objects].first(iri: iri)
          return unless found

          ActivityStreams.from_json(found[:json])
        end

        def get_fresh(iri)
          puts "SocialWeb HTTP: #{iri}"
          # TODO: Replace with custom HTTP fetcher
          sleep 0.5
          res = HTTP.headers(accept: 'application/activity+json').get(iri)
          unless res.status.success?
            puts "SocialWeb HTTP: Failed req: #{res.to_a}"
            return
          end

          obj = ActivityStreams.from_json(res.body.to_s)
          store(obj)
          obj
        end

        def insert_object(obj)
          return if stored?(obj.id)

          now = Time.now.utc

          SocialWeb::Rack.db[:social_web_objects].insert(
            iri: obj.id,
            type: obj.type,
            json: obj.to_json,
            created_at: now
          )
        end

        def insert_relationship(parent:, child:, prop:)
          SocialWeb::Rack.db[:social_web_relationships].insert(
            type: prop.to_s,
            parent_iri: parent.id,
            child_iri: child.id,
            created_at: Time.now.utc
          )
        end

        def loop_count
          @loop_count ||= 0
        end
      end
    end
  end
end
