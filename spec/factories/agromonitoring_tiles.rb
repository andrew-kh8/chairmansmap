# typed: false

FactoryBot.define do
  factory :agromonitoring_tile do
    association :village
    date { Time.current }
    satellite { "Satellite" }
    valid_data_coverage { 100 }
    cloud_coverage { 0 }
    truecolor_url { "http://example.com/truecolor" }
    falsecolor_url { "http://example.com/falsecolor" }
    ndvi_url { "http://example.com/ndvi" }
    evi_url { "http://example.com/evi" }
    evi2_url { "http://example.com/evi2" }
    nri_url { "http://example.com/nri" }
    dswi_url { "http://example.com/dswi" }
    ndwi_url { "http://example.com/ndwi" }
  end
end
