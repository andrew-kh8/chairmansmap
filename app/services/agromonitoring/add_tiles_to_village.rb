# typed: strict

module Agromonitoring
  class AddTilesToVillage
    extend T::Sig

    class Result < T::Struct
      extend T::Sig

      const :village, Village
      const :available_dates, T::Array[Time]
      const :new_tiles, T::Array[AgromonitoringTile]
      const :invalid_tiles, T::Array[AgromonitoringTile]
      const :error, T.nilable(Apis::Agromonitoring::Client::AgromonitoringError)
    end

    sig { params(village: Village, from: Time, to: Time).returns(Result) }
    def self.call(village, from: 1.week.ago, to: Time.zone.now)
      images_date = Apis::Agromonitoring::Client.new.polygon_images(village.agromonitoring_id, from.to_i, to.to_i)
      available_dates = []
      new_tiles = []
      invalid_tiles = []

      images_date.each do |image_date|
        available_dates << image_date.date

        tile = village.agromonitoring_tiles.new(
          date: image_date.date,
          satellite: image_date.satellite,
          valid_data_coverage: image_date.valid_data_coverage,
          cloud_coverage: image_date.cloud_coverage,
          truecolor_url: image_date.tile.truecolor,
          falsecolor_url: image_date.tile.falsecolor,
          ndvi_url: image_date.tile.ndvi,
          evi_url: image_date.tile.evi,
          evi2_url: image_date.tile.evi2,
          nri_url: image_date.tile.nri,
          dswi_url: image_date.data.dswi,
          ndwi_url: image_date.data.ndwi
        )

        if tile.valid?
          tile.save!
          new_tiles << tile
        else
          invalid_tiles << tile
          next
        end
      end

      Result.new(village:, available_dates:, invalid_tiles:, new_tiles:)
    rescue Apis::Agromonitoring::Client::AgromonitoringError => error
      Result.new(
        village:,
        available_dates: available_dates || [],
        invalid_tiles: invalid_tiles || [],
        new_tiles: new_tiles || [],
        error:
      )
    end
  end
end
