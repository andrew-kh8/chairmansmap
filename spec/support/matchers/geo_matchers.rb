# typed: false

RSpec::Matchers.define :has_xy_coords do |x, y, tolerance = 8|
  match do |actual|
    actual.x.floor(tolerance) == x.floor(tolerance) &&
      actual.y.floor(tolerance) == y.floor(tolerance)
  end

  description do
    "has coord x eq #{x} and coord y eq #{y}"
  end

  failure_message do |actual|
    "expected that #{actual} has coord x eq #{x} and coord y eq #{y}"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} hasn't coord x eq #{x} and coord y eq #{y}"
  end
end

RSpec::Matchers.define :eq_wkt_point do |wkt_point, tolerance = 8|
  match do |wkt_actual_point|
    factory = RGeo::Geos.factory
    point = factory.parse_wkt(wkt_point)
    actual_point = factory.parse_wkt(wkt_actual_point)

    actual_point.x.floor(tolerance) == point.x.floor(tolerance) &&
      actual_point.y.floor(tolerance) == point.y.floor(tolerance)
  end

  description do
    "eq point in WKT format"
  end

  failure_message do |actual|
    "expected that #{wkt_actual_point} eq #{wkt_point} with WKT format"
  end

  failure_message_when_negated do |actual|
    "expected that #{wkt_actual_point} not eq #{wkt_point} with WKT format"
  end
end
