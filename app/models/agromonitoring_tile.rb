# typed: strict

class AgromonitoringTile < ApplicationRecord
  NORMAL_CLOUD_COVERAGE = 70
  NORMAL_VALID_DATA_COVERAGE = 30

  belongs_to :village

  validates :date, :satellite, :valid_data_coverage, :cloud_coverage, presence: true
  validates :truecolor_url, :falsecolor_url, :ndvi_url, :evi_url, :evi2_url, :nri_url, :dswi_url, :ndwi_url, presence: true
  validates :date, uniqueness: {scope: [:village_id, :satellite]}

  sig { returns(T::Boolean) }
  def normal_view?
    cloud_coverage <= NORMAL_CLOUD_COVERAGE && valid_data_coverage > NORMAL_VALID_DATA_COVERAGE
  end

  sig { returns(T::Hash[Symbol, String]) }
  def tile_urls
    {
      truecolor: truecolor_url,
      falsecolor: falsecolor_url,
      ndvi: ndvi_url,
      evi: evi_url,
      evi2: evi2_url,
      nri: nri_url,
      dswi: dswi_url,
      ndwi: ndwi_url
    }.compact_blank
  end
end
