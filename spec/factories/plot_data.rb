FactoryBot.define do
  factory :plot_datum do
    plot { create(:plot) }
    description { FFaker::Lorem.sentence }
    sale_status { "не продается" }
    owner_type { "государственная собственность" }
    kadastr_number { [
      FFaker::Number.number,
      FFaker::Number.number,
      FFaker::Number.number(digits: 3),
      FFaker::Number.number(digits: 6)
    ].join(":") }
  end
end
