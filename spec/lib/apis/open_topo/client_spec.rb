# typed: false

RSpec.describe Apis::OpenTopo::Client do
  let(:api_key) { ENV["OPEN_TOPOGRAPHY_API_KEY"] }
  let(:instance) { described_class.new(api_key) }
  let(:bounds) do
    {south: 37.496990299008004, north: 37.50225019316373, west: -92.4444501288235, east: -92.43777813389897}
  end

  describe "#globaldem" do
    subject { instance.globaldem(**bounds) }

    context "when response is successful" do
      after { File.delete(subject.original_file.path) }

      it "returns dem file built from response body" do
        VCR.use_cassette("api/open_topo/globaldem_success") do
          expect(subject.dem_type).to eq "SRTMGL3"
          expect(subject.output_format).to eq "GTiff"
        end
      end
    end

    context "when response is error" do
      let(:bounds) { {south: 10000, north: 37.50225019316373, west: -92.4444501288235, east: -92.43777813389897} }

      it "raises response error with api message" do
        VCR.use_cassette("api/open_topo/globaldem_error") do
          expect { instance.globaldem(**bounds) }
            .to raise_error(Apis::OpenTopo::Errors::ResponseError, "Error: Invalid latitude  (10000.0). It must be in range [-90, 90].")
        end
      end
    end
  end
end
