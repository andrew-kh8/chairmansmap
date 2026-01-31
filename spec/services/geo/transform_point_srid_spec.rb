RSpec.describe Geo::TransformPointSrid do
  subject(:result) { described_class.call(lng, lat, from_srid) }

  describe "#call" do
    let(:lng) { 44.50812782797782 }
    let(:lat) { 33.57758084622251 }
    let(:from_srid) { 4326 }

    it "returns location" do
      is_expected.to eq_wkt_point "POINT(4954622.125972421 3972221.5103468867)"
    end
  end
end
