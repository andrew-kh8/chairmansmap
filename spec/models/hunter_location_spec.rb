require "rails_helper"

RSpec.describe HunterLocation, type: :model do
  describe "validations" do
    subject { create(:hunter_location) }

    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:date) }
  end
end
