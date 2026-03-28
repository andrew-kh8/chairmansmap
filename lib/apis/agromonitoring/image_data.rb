# typed: strict
# frozen_string_literal: true

module Apis
  module Agromonitoring
    class ImageData < T::Struct
      class Images < T::Struct
        const :truecolor, T.nilable(String)
        const :falsecolor, T.nilable(String)
        const :ndvi, String
        const :evi, String
        const :evi2, String
        const :nri, String
        const :dswi, String
        const :ndwi, String
      end

      const :date, ActiveSupport::TimeWithZone
      const :satellite, String
      const :cloud_coverage, Float
      const :valid_data_coverage, Float

      const :image, Images
      const :tile, Images
      const :stats, Images
      const :data, Images
    end
  end
end
