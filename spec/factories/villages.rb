# typed: false

FactoryBot.define do
  factory :village do
    name { FFaker::Company.name }

    cadastral_number do
      [
        FFaker::Number.number,
        FFaker::Number.number,
        FFaker::Number.number(digits: 3)
      ].join(":")
    end

    geom do
      factory = RGeo::Geos.factory(srid: GeoConst::DEFAULT_DB_SRID)
      x = rand(-20037508.34..20037508.34)
      y = rand(-20048966.1..20048966.1)

      factory.multi_polygon([
        factory.polygon(
          factory.linear_ring([
            factory.point(x, y),
            factory.point(x + 1000, y),
            factory.point(x + 1000, y + 1000),
            factory.point(x, y + 1000),
            factory.point(x, y)
          ])
        )
      ])
    end
  end
end
