# frozen_string_literal: true

task :test do
  %w(
  activity_pub
  activity_streams
  social_web
  webmention
  well_known
)
  .each do |lib|
    lib_path = File.expand_path(File.join(__dir__, lib))
    Dir.chdir(lib_path) do
      puts "\n=== Testing #{lib } ============================================="
      `bundle install`
      system('bundle exec rspec')
    end
  end

end

task default: :test
