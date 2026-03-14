# typed: false

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join("spec/fixtures/vcr_cassettes")
  config.allow_http_connections_when_no_cassette = true
  config.hook_into :faraday
  config.default_cassette_options = {record: ENV["COVERAGE"] ? :none : :new_episodes}
  config.ignore_localhost = true

  config.filter_sensitive_data("<APPID>") { ENV["OPEN_WEATHER_API_KEY"] }
  config.filter_sensitive_data("<AGROMONITORING_API_KEY>") { ENV["AGROMONITORING_API_KEY"] }
end
