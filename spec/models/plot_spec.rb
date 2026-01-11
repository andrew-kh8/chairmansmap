require "rails_helper"

RSpec.describe Plot, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:owners).class_name("Owner") }
    it { is_expected.to have_one(:owner).class_name("Owner") }
    it { is_expected.to have_many(:persons).through(:owners).class_name("Person") }
    it { is_expected.to have_one(:person).through(:owner).class_name("Person") }
  end

  describe "validations" do
    subject { FactoryBot.build(:plot) }

    it { is_expected.to validate_presence_of(:geom) }
    it { is_expected.to validate_presence_of(:gid) }
    it { is_expected.to validate_presence_of(:area) }
    it { is_expected.to validate_presence_of(:perimeter) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_numericality_of(:number) }
    it { is_expected.to validate_uniqueness_of(:cadastral_number).ignoring_case_sensitivity }

    describe "cadastral_number format" do
      it { is_expected.to allow_value("12:34:1234567:123456789").for(:cadastral_number) }
      it { is_expected.to allow_value("1:2:3:4").for(:cadastral_number) }
      it { is_expected.not_to allow_value("invalid").for(:cadastral_number) }
      it { is_expected.not_to allow_value("12:34:1234567").for(:cadastral_number) }
    end
  end
end
