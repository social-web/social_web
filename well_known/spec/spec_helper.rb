# frozen_string_literal: true

require 'simplecov'
SimpleCov.add_filter(/spec/)
SimpleCov.start

require 'well_known'
require 'rack/test'
require 'helper'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :route
  config.include Helper

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.example_status_persistence_file_path = 'tmp/examples.txt'

  config.disable_monkey_patching!

  config.warnings = false
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
end
