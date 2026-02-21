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
  end
end
