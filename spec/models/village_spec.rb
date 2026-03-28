# typed: false

RSpec.describe Village, type: :model do
  subject { build(:village) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:geom) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:cadastral_number).allow_nil.ignoring_case_sensitivity }
    it { is_expected.to validate_uniqueness_of(:agromonitoring_id).allow_nil }
  end
end
