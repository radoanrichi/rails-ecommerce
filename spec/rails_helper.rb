# spec/rails_helper.rb

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rspec/rails'
require 'shoulda/matchers'

# Abort if the environment is running in production mode
abort('The Rails environment is running in production mode!') if Rails.env.production?

# Configure Shoulda Matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Check for pending migrations and apply them before tests are run
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Remove this line if not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # Automatically mix in different behaviours to your tests based on file location
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces
  config.filter_rails_from_backtrace!

  # Include FactoryBot syntax methods
  config.include FactoryBot::Syntax::Methods

  # Include Devise test helpers for controller tests
  config.include Devise::Test::ControllerHelpers, type: :controller
end
