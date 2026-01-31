FactoryBot.define do
  factory :plot do
    sequence(:number) { |n| n }
    area { FFaker::Number.decimal(whole_digits: 3) }
    perimeter { FFaker::Number.decimal(whole_digits: 2) }
    description { FFaker::Lorem.sentence }
    sale_status { "не продается" }
    owner_type { "государственная собственность" }
    cadastral_number do
      [
        FFaker::Number.number,
        FFaker::Number.number,
        FFaker::Number.number(digits: 3),
        FFaker::Number.number(digits: 6)
      ].join(":")
    end
    geom do
      factory = RGeo::Geos.factory(srid: Plot::SRID)
      x = rand(3737500..3737900)
      y = rand(5544000..5544500)

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
  end
end
