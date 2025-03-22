# frozen_string_literal: true

FactoryBot.define do
  factory :hunter_location do
    location { RGeo::Cartesian.simple_factory.point(rand(6_545_900..6_546_300), rand(4_930_400..4_930_800)) }
    date { DateTime.current }
    description { 'Description about hunter' }
    license { false }
    dog { false }
  end
end
