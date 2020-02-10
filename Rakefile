# frozen_string_literal: true

require 'bundler/setup'

require 'sequel'
require 'social_web/boot'

migrations_path = File.join(
  Gem::Specification.find_by_name('social_web').gem_dir,
  'db',
  'migrations'
)

tables = %i[
  social_web_collections
  social_web_keys
  social_web_objects
  social_web_relationships
  social_web_schema_migrations
]

def start_db
  SocialWeb::Container.start(:db)
end

namespace :social_web do
  namespace :db do
    desc 'Remove SocialWeb tables'
    task :drop_tables do
      start_db
      SocialWeb[:db].transaction do
        SocialWeb[:db].drop_table?(*tables,  cascade: true)
        puts 'Removed SocialWeb tables. ' \
          'Run `rake sequel:db:migrate` to add them.'
      end
    end

    desc 'Create SocialWeb tables'
    task :migrate do
      Sequel.extension :migration, :core_extensions

      start_db
      SocialWeb[:db].transaction do
        Sequel::Migrator.run(
          SocialWeb[:db],
          migrations_path,
          table: :social_web_schema_migrations
        )
        puts 'Created SocialWeb tables. ' \
          'Run `rake sequel:db:drop_tables` to remove them.'
      end
    end

    desc 'Print SocialWeb migrations'
    task :migrations do
      Dir[File.join(migrations_path, '*.rb')].each do |migration|
        puts File.read(migration)
      end
    end
  end
end
