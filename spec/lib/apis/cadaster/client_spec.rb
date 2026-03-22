# typed: false

RSpec.describe Apis::Cadaster::Client do
  describe ".plot_coords" do
    subject { instance.get_plot(cadaster_number) }

    let(:instance) { described_class.new }
    let(:cadaster_number) { "12:12:123123:999" }

    context "when response has coords" do
      it "returns success with coords" do
        VCR.use_cassette("api/cadaster/get_plot_coords") do
          expect(subject).to be_success
          expect(subject.payload).to be_an Apis::Cadaster::Polygon

          polygon = subject.payload
          expect(polygon.coordinates).to eq [[
            [1000001.100100, 2000001.200200],
            [1000002.100100, 2000002.200200],
            [1000003.100100, 2000003.200200],
            [1000004.100100, 2000004.200200],
            [1000001.100100, 2000001.200200]
          ]]
          expect(polygon.cadaster_number).to eq cadaster_number
          expect(polygon.inserted).to eq Time.zone.parse("2025-12-25T06:00:00+03:00")
          expect(polygon.updated).to eq Time.zone.parse("2026-03-12T22:00:00.00+03:00")
        end
      end
    end

    context "when response is error" do
      let(:cadaster_number) { "12:12:123123:99999999" }

      it "returns failure with error" do
        VCR.use_cassette("api/cadaster/fail_get_plot_coords") do
          expect(subject).to be_failure
          expect(subject.error.code).to eq 404
          expect(subject.error.message).to eq "Not Found"
        end
      end
    end
  end
end
