# typed: false

RSpec.configure do |config|
  geo_tables = ["spatial_ref_sys"]

  # https://github.com/DatabaseCleaner/database_cleaner?tab=readme-ov-file#rspec-with-capybara-example
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation, except: geo_tables)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :system) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    if !driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = [:truncation, except: geo_tables]
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
