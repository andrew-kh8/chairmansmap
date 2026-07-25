# typed: false

RSpec.describe Apis::OpenTopo::Errors::ResponseError do
  describe "#message" do
    context "when message is a hash with error key" do
      it "uses error value from hash" do
        error = described_class.new("error" => "Invalid API key")

        expect(error.message).to eq "Invalid API key"
      end
    end

    context "when message is a plain string" do
      it "uses the whole string" do
        error = described_class.new("Service unavailable")

        expect(error.message).to eq "Service unavailable"
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
