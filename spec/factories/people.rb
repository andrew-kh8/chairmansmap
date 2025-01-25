FactoryBot.define do
  factory :person do
    first_name { FFaker::NameRU.first_name }
    middle_name { [FFaker::NameRU.middle_name_female, FFaker::NameRU.middle_name_male].sample }
    surname { FFaker::NameRU.last_name }
    tel { FFaker::PhoneNumberRU.international_phone_number }
    address { "#{FFaker::AddressRU.province}, #{FFaker::AddressRU.city}, #{FFaker::AddressRU.street_address}" }
    birth { FFaker::Date.birthday }
    member_from { FFaker::Date.backward }

    trait :discarded do
      discarded_at { DateTime.current.in_time_zone("UTC") }
    end
  end
end
