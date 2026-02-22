# typed: false

RSpec.describe Apis::Cadaster::Client do
  describe ".plot_coords" do
    subject { described_class.plot_coords(cadaster_number) }

    let(:cadaster_number) { "123:123:456:789" }

    context "when response has coords" do
      it "returns success with coords" do
        VCR.use_cassette("api/cadaster/get_plot_coords") do
          expect(subject).to be_success
          expect(subject.success).to eq [[
            [1000001.100100, 2000001.200200],
            [1000002.100100, 2000002.200200],
            [1000003.100100, 2000003.200200],
            [1000004.100100, 2000004.200200],
            [1000001.100100, 2000001.200200]
          ]]
        end
      end
    end

    context "when response body is a text" do
      it "returns failure with error" do
        VCR.use_cassette("api/cadaster/fail_get_plot_coords") do
          expect(subject).to be_failure
          expect(subject.failure).to be_instance_of described_class::ResponseError
          expect(subject.failure.message).to eq "Couldn't send request"
        end
      end
    end

    context "when there is timeout error" do
      let(:fake_connection) { double }

      it "returns failure with error" do
        allow(fake_connection).to receive(:get).and_raise(Net::ReadTimeout, "test timeout")
        allow(described_class).to receive(:connection).and_return(fake_connection)

        expect(subject.failure).to be_instance_of described_class::RequestError
        expect(subject.failure.message).to eq "Net::ReadTimeout with \"test timeout\""
      end
    end
  end
end
