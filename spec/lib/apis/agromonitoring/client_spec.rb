# typed: false

RSpec.describe Apis::Agromonitoring::Client do
  let(:instance) { described_class.new }
  let(:polygon_id) { "687946sdfsdf68e4s65dg4" }

  describe "#list_polygons" do
    it "qwe" do
      VCR.use_cassette("api/agromonitoring/list_polygons") do
        result = instance.list_polygons
        expect(result).to be_present
      end
    end
  end

  describe "#polygon" do
    it "qwe" do
      VCR.use_cassette("api/agromonitoring/polygon") do
        result = instance.polygon(polygon_id)
        expect(result).to be_present
      end
    end
  end

  describe "#create_polygon" do
    let(:village) { create(:village) }
    let(:geo_json) do # mock coords
      {
        type: "Feature",
        geometry: {
          type: "Polygon",
          coordinates: [[[22.1001, 37.2002], [22.1003, 37.2003], [22.1004, 37.2004], [22.1005, 37.2005]]]
        },
        properties: {srid: 4326}
      }
    end

    it "qwe" do
      VCR.use_cassette("api/agromonitoring/create_polygon") do
        result = instance.create_polygon(name: village.name, geo_json: geo_json)
        expect(result).to be_present
      end
    end
  end

  describe "#delete_polygon" do
    it "qwe" do
      VCR.use_cassette("api/agromonitoring/delete_polygon") do
        result = instance.delete_polygon(polygon_id)
        expect(result).to be_empty
      end
    end
  end

  describe "#polygon_images" do
    it "qwe" do
      VCR.use_cassette("api/agromonitoring/polygon_images") do
        result = instance.polygon_images(polygon_id, Time.new(2026, 1, 5), Time.new(2026, 1, 10))
        expect(result).to be_present
      end
    end
  end
end
