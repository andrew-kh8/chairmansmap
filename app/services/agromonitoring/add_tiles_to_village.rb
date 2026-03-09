# typed: strict

module Agromonitoring
  class AddTilesToVillage
    extend T::Sig

    SLICE_DAYS = 7

    class Result < T::Struct
      extend T::Sig

      const :village, Village
      const :available_dates, T::Array[Time]
      const :new_tiles, T::Array[AgromonitoringTile]
      const :invalid_tiles, T::Array[AgromonitoringTile]
      const :error, T.nilable(Apis::Agromonitoring::Client::AgromonitoringError)
    end

    sig { returns(Village) }
    attr_reader :village

    sig { returns(T::Array[Time]) }
    attr_reader :available_dates

    sig { returns(T::Array[AgromonitoringTile]) }
    attr_reader :new_tiles

    sig { returns(T::Array[AgromonitoringTile]) }
    attr_reader :invalid_tiles

    sig { params(village: Village).void }
    def initialize(village)
      @village = T.let(village, Village)
      @available_dates = T.let([], T::Array[Time])
      @new_tiles = T.let([], T::Array[AgromonitoringTile])
      @invalid_tiles = T.let([], T::Array[AgromonitoringTile])
    end

    sig { params(from: Date, to: Date).returns(Result) }
    def call(from: 1.week.ago.to_date, to: Date.current)
      date_range = (from..to)

      date_range.each_slice(SLICE_DAYS).map do |week|
        Thread.new { pull_week_tiles(week) }
      end.each(&:join)

      Result.new(village:, available_dates:, invalid_tiles:, new_tiles:)
    rescue Apis::Agromonitoring::Client::AgromonitoringError => error
      Result.new(village:, available_dates:, invalid_tiles:, new_tiles:, error:)
    end

    private

    sig { params(week: T::Array[Date]).void }
    def pull_week_tiles(week)
      from_date = week.first
      to_date = week.last

      return if from_date.nil? || to_date.nil?

      week_images_date = Apis::Agromonitoring::Client.new
        .polygon_images(village.agromonitoring_id, from_date.to_time.to_i, to_date.to_time.to_i)

      week_images_date.each do |image_date|
        available_dates << image_date.date
        image_date_tile = image_date.tile

        tile = village.agromonitoring_tiles.new(
          date: image_date.date,
          satellite: image_date.satellite,
          valid_data_coverage: image_date.valid_data_coverage,
          cloud_coverage: image_date.cloud_coverage,
          truecolor_url: image_date_tile.truecolor,
          falsecolor_url: image_date_tile.falsecolor,
          ndvi_url: image_date_tile.ndvi,
          evi_url: image_date_tile.evi,
          evi2_url: image_date_tile.evi2,
          nri_url: image_date_tile.nri,
          dswi_url: image_date_tile.dswi,
          ndwi_url: image_date_tile.ndwi
        )

        if tile.valid? && tile.normal_view?
          tile.save!
          new_tiles << tile
        else
          invalid_tiles << tile
        end
      rescue ActiveRecord::RecordInvalid => _error
        invalid_tiles << tile if tile.present?
        next
      end
    end
  end
end
