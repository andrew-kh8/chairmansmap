# typed: false

RSpec.describe HunterLocationGeometry do
  describe ".call" do
    subject { described_class.call }

    context "when there are hunter locations" do
      let!(:h_location1) { create(:hunter_location, date: Date.new(2026, 1, 10)) }
      let!(:h_location2) { create(:hunter_location, date: Date.new(2026, 1, 15)) }

      let(:dates) { subject.map(&:date) }
      let(:first_hl_geojson) { subject.first.geojson_geom }

      it "returns an array of HunterLocationGeojson structs" do
        expect(subject.size).to eq(2)
        expect(subject.first).to be_a(described_class::HunterLocationGeojson)
      end

      it "includes date for each location" do
        expect(dates).to match_array([h_location1.date, h_location2.date])
      end

      it "transforms coordinates to WGS84 (SRID 4326)" do
        expect(first_hl_geojson).to be_a(Hash)
        expect(first_hl_geojson["type"]).to eq("Point")
        expect(first_hl_geojson["coordinates"].size).to eq(2)
      end
    end

    context "when there is a single hunter location" do
      let!(:location) { create(:hunter_location, date: Date.new(2026, 1, 20)) }

      let(:result) { subject.first }

      it "returns one element" do
        expect(subject.size).to eq(1)
        expect(result.date).to eq(location.date)
      end
    end

    context "when there are no hunter locations" do
      it "returns an empty array" do
        expect(subject).to eq([])
      end
    end
  end
end
