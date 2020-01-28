# frozen_string_literal: true

module SocialWeb
  module Rack
    module Repositories
      class Objects
        def add(obj)
          return obj if stored?(obj)

          objects.insert(
            iri: obj[:id],
            type: obj.type,
            json: obj.to_json,
            created_at: Time.now.utc
          )

          obj
        end

        def deep_add(obj)
          add(obj)

          SocialWeb['rack.traverse_relationships'].call(obj) do |parent, rel, child|
            if child.is_a?(String) && child.match?(/^#{URI.regexp}$/)
              child = get_by_iri(child)
            end

            if child.is_a?(ActivityStreams)
              add(child)
              insert_relationship(parent: parent, child: child, prop: rel)
            end

            parent[rel] = child
          end

          obj
        end

        def get_by_iri(iri)
          found = get_from_cache(iri) || get_fresh(iri)
          return if found.nil?

          ActivityStreams.from_json(found)
        end

        def reconstitute(obj)
          SocialWeb['rack.traverse_relationships'].call(obj) do |parent, rel, child|
            if child.is_a?(String) && child.match?(/^#{URI.regexp}$/)
              child = get_by_iri(child)
            end

            parent[rel] = child
          end
        end

        def remove(obj)
          objects.by_iri(obj[:id]).delete
        end

        def replies_for_iri(iri)
          cache = {}

          objects.traverse(iri).where(rel_type: 'inReplyTo').map do |record|
            parent_iri = record[:parent_iri]
            child_iri = record[:child_iri]
            parent_json = record[:parent_json]
            child_json = record[:child_json]
            rel_type = record[:rel_type]

            if cache[parent_iri]
              parent = cache[parent_iri]
            else
              parent = ActivityStreams.from_json(parent_json)
              cache[parent[:id]] = parent
            end

            if cache[child_iri]
              child = cache[child_iri]
            else
              child = ActivityStreams.from_json(child_json)
              cache[child[:id]] = child
            end

            parent[rel_type] = child

            child[:replies][:items] ||= []
            child[:replies][:items] << parent

            parent
          end
        end

        private

        def get_from_cache(iri)
          found = objects.by_iri(iri).first
          return if found.nil?

          found[:json]
        end

        def get_fresh(iri)
          puts "SocialWeb HTTP GET: #{iri}"

          # TODO: Replace with custom HTTP fetcher
          sleep 0.5

          res = SocialWeb['http_client'].get(iri)
          unless res.status.success?
            puts "SocialWeb HTTP: Failed req: #{res.to_a}"
            return
          end

          json = res.body.to_s
          obj = ActivityStreams.from_json(json)
          add(obj)
          json
        end

        # { parent => prop => child }
        # e.g. { obj1 => inReplyTo => obj2 }
        def insert_relationship(parent:, child:, prop:)
          found = SocialWeb::Rack.db[:social_web_relationships].where(
            parent_iri: parent[:id], child_iri: child[:id], type: prop.to_s
          ).first
          return if found

          SocialWeb::Rack.db[:social_web_relationships].insert(
            type: prop.to_s,
            parent_iri: parent[:id],
            child_iri: child[:id],
            created_at: Time.now.utc
          )
        end

        def objects
          SocialWeb['objects_rel']
        end

        def stored?(obj)
          found = objects.by_iri(obj[:id]).first
          !found.nil?
        end
      end
    end
  end
end
