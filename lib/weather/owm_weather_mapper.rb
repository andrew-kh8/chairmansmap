# typed: strict

module Weather
  class OwmWeatherMapper
    WIND_DIRECTIONS = ["С", "СВ", "В", "ЮВ", "Ю", "ЮЗ", "З", "СЗ"]
    OCTANT_DEGREE = 45

    class << self
      extend T::Sig

      sig { params(raw_data: OpenWeather::Models::City::Weather).returns(::Weather::Weather) }
      def call(raw_data)
        raw_data_main = raw_data.main
        raw_data_weather = raw_data.weather.first

        coord_data = get_coord_from_raw(raw_data)
        wind_data = get_wind_from_raw(raw_data.wind)
        temp_data = get_temperature_from_raw(raw_data_main)

        ::Weather::Weather.new(
          coords: coord_data,
          wind: wind_data,
          temperature: temp_data,
          date: raw_data.dt,
          clouds: raw_data.clouds.all,
          rain: raw_data.rain&.fetch("1h"),
          snow: raw_data.snow&.fetch("1h"),
          visibility: raw_data.visibility,
          humidity: raw_data_main.humidity.to_f,
          pressure: raw_data_main.pressure.to_f,
          description: raw_data_weather.description,
          main: raw_data_weather.main,
          icon_uri: raw_data_weather.icon_uri.to_s
        )
      end

      private

      sig { params(raw_data: OpenWeather::Models::City::Weather).returns(::Weather::Weather::Coord) }
      def get_coord_from_raw(raw_data)
        raw_data_sys = raw_data.sys

        ::Weather::Weather::Coord.new(
          lon: raw_data.coord.lon,
          lat: raw_data.coord.lat,
          city: raw_data.name,
          city_id: raw_data.id,
          country: raw_data_sys.country,
          sunrise: raw_data_sys.sunrise,
          sunset: raw_data_sys.sunset
        )
      end

      sig { params(raw_wind_data: OpenWeather::Models::Wind).returns(::Weather::Weather::Wind) }
      def get_wind_from_raw(raw_wind_data)
        ::Weather::Weather::Wind.new(
          speed: raw_wind_data.speed.round(1),
          deg: raw_wind_data.deg,
          direction: get_wind_direction(raw_wind_data.deg)
        )
      end

      sig { params(raw_main_data: OpenWeather::Models::Main).returns(::Weather::Weather::Temperature) }
      def get_temperature_from_raw(raw_main_data)
        ::Weather::Weather::Temperature.new(
          temp: raw_main_data.temp.round(1),
          feels_like: raw_main_data.feels_like.round(1),
          min: raw_main_data.temp_min.round(1),
          max: raw_main_data.temp_max.round(1)
        )
      end

      sig { params(deg: T.any(Integer, Float)).returns(String) }
      def get_wind_direction(deg)
        octant = ((deg + (OCTANT_DEGREE / 2.0)) / OCTANT_DEGREE).floor
        wind_direction = (octant > 7) ? octant - 8 : octant
        T.must(WIND_DIRECTIONS[wind_direction])
      end
    end
  end
end
