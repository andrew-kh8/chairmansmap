FactoryBot.define do
  factory :hunter_location do
    location { RGeo::Cartesian.simple_factory.point(rand(6545900..6546300), rand(4930400..4930800)) }
    date { DateTime.current }
    description { "Description about hunter" }
    license { false }
    dog { false }
  end
end
