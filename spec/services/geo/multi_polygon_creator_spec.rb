# typed: false

RSpec.describe Geo::MultiPolygonCreator do
  subject { described_class.call(coords) }

  describe ".call" do
    context "when coordinates are valid and form a closed ring" do
      let(:coords) { [[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]] }
      let(:result) { subject.success }

      it "returns success" do
        expect(subject).to be_success

        expect(result.multi_polygon).to be_a(RGeo::Geos::CAPIMultiPolygonImpl)
        expect(result.area).to eq 100
        expect(result.perimeter).to eq 40
      end
    end

    context "when coordinates do not form a closed ring" do
      let(:coords) { [[0, 0], [10, 0], [10, 10]] }

      it "returns failure" do
        expect(subject).to be_failure
        expect(subject.failure).to eq "The coordinates are not closed in a circle"
      end
    end
  end
end
