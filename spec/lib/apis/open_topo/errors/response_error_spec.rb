# typed: false

RSpec.describe Apis::OpenTopo::Errors::ResponseError do
  describe "#message" do
    context "when message is a hash with error key" do
      let(:error_message) { "Invalid API key" }

      it "uses error value from hash" do
        error = described_class.new("error" => error_message)

        expect(error.message).to eq error_message
      end
    end

    context "when message is a plain string" do
      let(:error_message) { "Service unavailable" }

      it "uses the whole string" do
        error = described_class.new(error_message)

        expect(error.message).to eq error_message
      end
    end

    context "when message is a hash without error key" do
      it "falls back to the whole message" do
        error = described_class.new({"status" => 500})

        expect(error.message).to eq '{"status"=>500}'
      end
    end
  end
end
