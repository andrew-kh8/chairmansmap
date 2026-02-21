# typed: false

RSpec.describe Weather::OwmWeatherMapper do
  describe ".call" do
    subject(:result) { described_class.call(raw_data) }

    let(:raw_data) do
      VCR.use_cassette("weather/owm_current_weather_by_coords") do
        OpenWeather::Client.new.current_weather(lat: 69.123, lon: 67.456)
      end
    end

    context "when raw data is valid" do
      it "returns weather object with valid coord object" do
        coords = result.coords
        expect(coords.lon).to eq 67.456
        expect(coords.lat).to eq 69.123
        expect(coords.city).to eq "Province of Turin"
        expect(coords.city_id).to eq 3165523
        expect(coords.country).to eq "IT"
        expect(coords.sunrise).to eq Time.new("2024-09-18 05:13:04.000000000 +0000")
        expect(coords.sunset).to eq Time.new("2024-09-18 17:36:15.000000000 +0000")
      end

      it "returns weather object with valid wind object" do
        wind = result.wind
        expect(wind.speed).to eq 4.1
        expect(wind.deg).to eq 121
        expect(wind.direction).to eq "ЮВ"
      end

      it "returns weather object with valid temperature object" do
        temperature = result.temperature
        expect(temperature.temp).to eq(13.3)
        expect(temperature.feels_like).to eq(11.8)
        expect(temperature.min).to eq(-20.3)
        expect(temperature.max).to eq(13.3)
      end

      it "returns weather object with valid attributes" do
        expect(result.date).to eq Time.new("2024-09-18 11:59:18.000000000 +0000")
        expect(result.clouds).to eq 83
        expect(result.rain).to eq 2.73
        expect(result.snow).to be_nil
        expect(result.visibility).to eq 10_000
        expect(result.humidity).to eq 94
        expect(result.pressure).to eq 1009
        expect(result.description).to eq "переменная облачность"
        expect(result.main).to eq "Clouds"
        expect(result.icon_uri).to eq "http://openweathermap.org/img/wn/03d@2x.png"
      end
    end
  end

  describe "#get_wind_direction" do
    subject { described_class.send(:get_wind_direction, deg) }

    context "when deg is 0" do
      let(:deg) { 0 }
      it { is_expected.to eq "С" }
    end

    context "when deg is 22.4" do
      let(:deg) { 22.4 }
      it { is_expected.to eq "С" }
    end

    context "when deg is 22.5" do
      let(:deg) { 22.5 }
      it { is_expected.to eq "СВ" }
    end

    context "when deg is 157.4" do
      let(:deg) { 157.4 }
      it { is_expected.to eq "ЮВ" }
    end

    context "when deg is 157.5" do
      let(:deg) { 157.5 }
      it { is_expected.to eq "Ю" }
    end

    context "when deg is 359" do
      let(:deg) { 359 }
      it { is_expected.to eq "С" }
    end
  end
end
