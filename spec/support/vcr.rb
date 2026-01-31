VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join("spec/fixtures/vcr_cassettes")
  config.allow_http_connections_when_no_cassette = true
  config.hook_into :faraday
end
