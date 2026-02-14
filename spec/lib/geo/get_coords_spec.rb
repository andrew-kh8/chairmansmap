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

  context "when client returns success" do
    it "returns coords" do
      expect(Apis::Geoplys::Client).to receive(:plot_coords).with(cadaster_number).and_return(DM::Success(coords))

      expect(subject).to be_success
      expect(subject.success).to eq coords
    end
  end

  context "when client returns failure" do
    it "returns coords" do
      expect(Apis::Geoplys::Client).to receive(:plot_coords).with(cadaster_number).and_return(DM::Failure("example error"))

      expect(subject).to be_failure
      expect(subject.failure).to eq "example error"
    end
  end
end
