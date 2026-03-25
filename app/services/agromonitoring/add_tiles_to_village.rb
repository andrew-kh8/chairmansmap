# typed: strict

module Agromonitoring
  class AddTilesToVillage
    extend T::Sig

    SLICE_DAYS = 7

    class Result < T::Struct
      extend T::Sig

      const :village, Village
      const :available_dates, T::Array[ActiveSupport::TimeWithZone]
      const :new_tiles, T::Array[AgromonitoringTile]
      const :invalid_tiles, T::Array[AgromonitoringTile]
      const :error, T.nilable(Apis::Agromonitoring::Client::AgromonitoringError)
    end

    sig { returns(Village) }
    attr_reader :village

    sig { returns(T::Array[ActiveSupport::TimeWithZone]) }
    attr_reader :available_dates

    sig { returns(T::Array[AgromonitoringTile]) }
    attr_reader :new_tiles

    sig { returns(T::Array[AgromonitoringTile]) }
    attr_reader :invalid_tiles

    sig { params(village: Village).void }
    def initialize(village)
      @village = T.let(village, Village)
      @available_dates = T.let([], T::Array[ActiveSupport::TimeWithZone])
      @new_tiles = T.let([], T::Array[AgromonitoringTile])
      @invalid_tiles = T.let([], T::Array[AgromonitoringTile])
    end

    sig { params(from: Date, to: Date).returns(Result) }
    def call(from: 1.week.ago.to_date, to: Date.current)
      date_range = (from..to)

      date_range.each_slice(SLICE_DAYS).filter_map do |week|
        Thread.new { pull_week_tiles(week.first, week.last) }
      end.each(&:join)

      Result.new(village:, available_dates:, invalid_tiles:, new_tiles:)
    rescue Apis::Agromonitoring::Client::AgromonitoringError => error
      Result.new(village:, available_dates:, invalid_tiles:, new_tiles:, error:)
    end

    private

    sig { params(from_date: Date, to_date: Date).void }
    def pull_week_tiles(from_date, to_date)
      week_images_date = Apis::Agromonitoring::Client.new.polygon_images(T.must(village.agromonitoring_id), from_date, to_date)
      mapper = ImageDataToTilesMapper.new(village)

      week_images_date.each do |image_date|
        available_dates << image_date.date

        tile = mapper.call(image_date)

        if tile.normal_view? && tile.save
          new_tiles << tile
        else
          invalid_tiles << tile
        end
      end
    end
  end
end
