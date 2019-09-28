# frozen_string_literal: true

migrations_path = File.join(
  Gem::Specification.find_by_name('social_web').gem_dir,
  'db',
  'migrations'
)

namespace :social_web do
  namespace :db do
    desc 'Remove SocialWeb tables'
    task :drop_tables do
      SocialWeb::Web.db.transaction do
        SocialWeb::Web.db.drop_table(
          :social_web_activities,
          :social_web_actors,
          :social_web_actor_activities,
          :social_web_actor_actors,
          :social_web_schema_migrations,
          cascade: true
        )
        puts 'Removed SocialWeb tables. ' \
        'Run `rake sequel:db:migrate` to add them.'
      end
    end

    desc 'Create SocialWeb tables'
    task :migrate do
      Sequel.extension :migration, :core_extensions
      Sequel::Migrator.run(
        SocialWeb::Web.db,
        migrations_path,
        table: :social_web_schema_migrations
      )
      puts 'Created SocialWeb tables. ' \
        'Run `rake sequel:db:drop_tables` to remove them.'
    end

    desc 'Print SocialWeb migrations'
    task :migrations do
      Dir[File.join(migrations_path, '*.rb')].each do |migration|
        puts File.read(migration)
      end
    end
  end
end
