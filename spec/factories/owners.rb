FactoryBot.define do
  factory :owner do
    plot { create(:plot) }
    person { create(:person) }
    active_from { Date.new(2022, 12, 12) }
    active_to { nil }
  end
end
