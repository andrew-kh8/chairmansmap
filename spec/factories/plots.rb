FactoryBot.define do
  factory :plot do
    sequence(:gid) { |n| n }
    area { FFaker::Number.decimal(whole_digits: 3) }
    perimetr { FFaker::Number.decimal(whole_digits: 2) }
    geom do
      factory = RGeo::Cartesian.simple_factory
      x = rand(6545959..6546308)
      y = rand(4930381..4930708)

      factory.multi_polygon([
        factory.polygon(
          factory.linear_ring([
            factory.point(x, y),
            factory.point(x + 20, y),
            factory.point(x + 20, y + 20),
            factory.point(x, y + 20),
            factory.point(x, y)
          ])
        )
      ])
    end

    after(:build) do |plot|
      plot.number = FFaker::Number.number(digits: 4)
    end

    after(:create) do |plot|
      plot.update(number: FFaker::Number.number(digits: 4))
    end
  end
end
