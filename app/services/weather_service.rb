# typed: strict

class WeatherService
  extend T::Sig

  sig { params(plot: Plot).returns(T.nilable(Weather::Weather)) }
  def self.get_by_plot(plot)
    plot_center = Geo::UnprojectPlot.call(plot).centroid

    raw_weather_data = Rails.cache.fetch("weather_plot_#{plot.id}", expires_in: 1.hour) do
      OpenWeather::Client.new.current_weather(lat: plot_center.lat, lon: plot_center.lon)
    end

    Weather::OwmWeatherMapper.call(raw_weather_data)
  rescue => _error
    nil
  end
end
