# typed: false

OpenWeather::Client.configure do |config|
  config.api_key = ENV["OPEN_WEATHER_API_KEY"]
  config.lang = "ru"
  config.units = "metric"
  config.logger = Rails.logger
end
