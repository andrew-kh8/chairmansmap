# typed: false

require "rails_helper"

RSpec.describe WeatherService do
  describe ".get_by_plot" do
    let(:plot) { create(:plot) }
    let(:fake_plot) { double }
    let(:fake_plot_center) { double }

    it "fetches weather data correctly" do
      allow(Geo::UnprojectPlot).to receive(:call).with(plot).and_return(fake_plot)
      allow(fake_plot).to receive(:centroid).and_return(fake_plot_center)
      allow(fake_plot_center).to receive(:lat).and_return(69.123)
      allow(fake_plot_center).to receive(:lon).and_return(67.456)

      VCR.use_cassette("weather/owm_current_weather_by_coords") do
        weather = described_class.get_by_plot(plot)

        expect(weather.temperature.temp).to eq(13.3)
        expect(weather.icon_uri).to eq("http://openweathermap.org/img/wn/03d@2x.png")
        expect(weather.description).to eq("переменная облачность")
        expect(weather.wind.speed).to eq(4.1)
        expect(weather.pressure).to eq(1009)
        expect(weather.humidity).to eq(94)
      end
    end
  end
end
