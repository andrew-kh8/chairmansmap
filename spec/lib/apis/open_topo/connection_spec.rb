# typed: false

RSpec.describe Apis::OpenTopo::Connection do
  describe "#build" do
    context "when api key is provided" do
      it "builds connection with base url, api key and headers" do
        connection = described_class.new("test-key").build

        expect(connection.url_prefix.to_s).to eq "https://portal.opentopography.org/"
        expect(connection.params["API_Key"]).to eq "test-key"
        expect(connection.headers["Accept"]).to eq "application/octet-stream"
        expect(connection.headers["User-Agent"]).to eq "Ruby on rails"
      end
    end

    context "when api key is not provided" do
      it "builds connection without api key param value" do
        connection = described_class.new.build

        expect(connection.params["API_Key"]).to be_nil
      end
    end
  end
end
