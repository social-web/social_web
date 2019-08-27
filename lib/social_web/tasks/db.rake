# frozen_string_literal: true

gem_dir = File.join(
  Gem::Specification.find_by_name('social_web').gem_dir,
  'lib',
  'social_web'
)

namespace :social_web do
  namespace :db do
    desc 'Remove SocialWeb tables'
    task :drop_tables do
      SocialWeb.db.transaction do
        SocialWeb.db.drop_table(
          :social_web_object_versions,
          :social_web_objects,
          :social_web_activities,
          :social_web_schema_migrations
        )
        puts 'Removed SocialWeb tables. ' \
        'Run `rake sequel:db:migrate` to add them.'
      end
    end

    desc 'Create SocialWeb tables'
    task :migrate do
      Sequel.extension :migration, :core_extensions
      Sequel::Migrator.run(
        SocialWeb.db,
        File.join(gem_dir,'db', 'migrations'),
        table: :social_web_schema_migrations
      )
      puts 'Created SocialWeb tables. ' \
        'Run `rake sequel:db:drop_tables` to remove them.'
    end

    desc 'Print SocialWeb migrations'
    task :migrations do
      Dir[File.join(gem_dir,'db', 'migrations', '*.rb')].each do |migration|
        puts File.read(migration)
      end
    end
  end
end
