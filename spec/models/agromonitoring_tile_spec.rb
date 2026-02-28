# typed: false

RSpec.describe AgromonitoringTile, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:village) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:satellite) }
    it { is_expected.to validate_presence_of(:valid_data_coverage) }
    it { is_expected.to validate_presence_of(:cloud_coverage) }

    %i[truecolor_url falsecolor_url ndvi_url evi_url evi2_url nri_url dswi_url ndwi_url].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end

    describe "uniqueness" do
      subject { build(:agromonitoring_tile) }

      it { is_expected.to validate_uniqueness_of(:date).scoped_to(:village_id, :satellite).ignoring_case_sensitivity }
    end
  end

  describe "#normal_view?" do
    let(:tile) { build(:agromonitoring_tile, cloud_coverage: cloud, valid_data_coverage: valid_data) }

    context "when cloud coverage is low and valid data coverage is high" do
      let(:cloud) { 20 }
      let(:valid_data) { 80 }

      it { expect(tile.normal_view?).to be true }
    end

    context "when cloud coverage is exactly at the limit" do
      let(:cloud) { 30 }
      let(:valid_data) { 80 }

      it { expect(tile.normal_view?).to be true }
    end

    context "when cloud coverage is high" do
      let(:cloud) { 40 }
      let(:valid_data) { 80 }

      it { expect(tile.normal_view?).to be false }
    end

    context "when valid data coverage is low" do
      let(:cloud) { 10 }
      let(:valid_data) { 60 }

      it { expect(tile.normal_view?).to be false }
    end

    context "when valid data coverage is exactly at the limit" do
      let(:cloud) { 10 }
      let(:valid_data) { 70 }

      it { expect(tile.normal_view?).to be false }
    end
  end
end
