# typed: false

class AgromonitoringTile < ApplicationRecord
  NORMAL_CLOUD_COVERAGE = 30
  NORMAL_VALID_DATA_COVERAGE = 70

  belongs_to :village

  validates :date, :satellite, :valid_data_coverage, :cloud_coverage, presence: true
  validates :truecolor_url, :falsecolor_url, :ndvi_url, :evi_url, :evi2_url, :nri_url, :dswi_url, :ndwi_url, presence: true
  validates :date, uniqueness: {scope: [:village_id, :satellite]}

  def normal_view?
    cloud_coverage <= NORMAL_CLOUD_COVERAGE && valid_data_coverage > NORMAL_VALID_DATA_COVERAGE
  end
end
