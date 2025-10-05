require 'rails_helper'

RSpec.describe HunterLocation, type: :model do
  describe 'validations' do
    subject { create(:hunter_location) }

    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_presence_of(:date) }
  end

  describe ".build_point_from_srid" do
    subject { described_class.build_point_from_srid(lng, lat) }

    let(:lng) { 44.50812782797782 }
    let(:lat) { 33.57758084622251 }

    it "returns location" do
      is_expected.to eq "POINT(4954622.125972421 3972221.5103468867)"
    end
  end
end
