# typed: strict

module Agromonitoring
  class ImageDataToTilesMapper
    extend T::Sig

    sig { params(village: Village).void }
    def initialize(village)
      @village = T.let(village, Village)
    end

    sig { params(image_data: Apis::Agromonitoring::ImageData).returns(AgromonitoringTile) }
    def call(image_data)
      image_data_tile = image_data.tile

      @village.agromonitoring_tiles.new(
        date: image_data.date,
        satellite: image_data.satellite,
        valid_data_coverage: image_data.valid_data_coverage,
        cloud_coverage: image_data.cloud_coverage,
        truecolor_url: image_data_tile.truecolor,
        falsecolor_url: image_data_tile.falsecolor,
        ndvi_url: image_data_tile.ndvi,
        evi_url: image_data_tile.evi,
        evi2_url: image_data_tile.evi2,
        nri_url: image_data_tile.nri,
        dswi_url: image_data_tile.dswi,
        ndwi_url: image_data_tile.ndwi
      )
    end
  end
end
