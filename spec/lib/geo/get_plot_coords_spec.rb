# typed: false

RSpec.describe Geo::GetPlotCoords do
  subject { described_class.call(cadaster_number) }

  let(:cadaster_number) { "123:123:456:789" }
  let(:coords) do
    [
      [1000001.100100, 2000001.200200],
      [1000002.100100, 2000002.200200],
      [1000001.100100, 2000001.200200]
    ]
  end
  let(:client_double) { instance_double(Apis::Cadaster::Client) }

  context "when client returns success" do
    it "returns coords" do
      double_response = double
      allow(double_response).to receive(:coordinates).and_return(coords)
      expect(Apis::Cadaster::Client).to receive(:new).and_return(client_double)
      expect(client_double).to receive(:get_plot).with(cadaster_number).and_return(Typed::Success.new(double_response))

      expect(subject).to be_success
      expect(subject.payload).to eq coords
    end
  end

  context "when client returns failure" do
    it "returns object with error message" do
      expect(Apis::Cadaster::Client).to receive(:new).and_return(client_double)
      expect(client_double).to receive(:get_plot).with(cadaster_number).and_return(Typed::Failure.new("blah-blah"))

      expect(subject).to be_failure
      expect(subject.error).to eq "Response body is empty"
    end
  end
end
