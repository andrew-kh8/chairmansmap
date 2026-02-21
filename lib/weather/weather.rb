# typed: strict

module Weather
  class Weather < T::Struct
    class Coord < T::Struct
      const :lon, Float
      const :lat, Float
      const :city, T.nilable(String)
      const :city_id, T.nilable(Integer)
      const :country, T.nilable(String)
      const :sunrise, Time
      const :sunset, Time
    end

    class Wind < T::Struct
      const :speed, Float
      const :deg, Integer
      # const :gust, T.nilable(Float) # looks like gem haven't support gust data
      const :direction, String
    end

    class Temperature < T::Struct
      const :temp, Float
      const :feels_like, Float
      const :min, Float
      const :max, Float
    end

    const :coords, Coord
    const :wind, Wind
    const :temperature, Temperature

    const :date, Time
    const :clouds, Integer
    const :rain, T.nilable(Float)
    const :snow, T.nilable(Float)
    const :visibility, Integer
    const :humidity, Float
    const :pressure, Float
    const :description, String
    const :main, String
    const :icon_uri, String
  end
end
