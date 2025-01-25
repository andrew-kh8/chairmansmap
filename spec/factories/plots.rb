FactoryBot.define do
  factory :plot do
    sequence(:gid) {|n| n }
    area { FFaker::Number.decimal(whole_digits:3) }
    perimetr { FFaker::Number.decimal(whole_digits:2) }
    geom { RGeo::Cartesian::simple_factory.multi_polygon([]) }

    after(:build) do |plot|
      plot.number = FFaker::Number.number(digits: 4)
    end

    after(:create) do |plot|
      plot.update(number: FFaker::Number.number(digits: 4))
    end
  end
end
