# typed: false

RSpec.describe Apis::OpenTopo::Converters::StringToTifConverter do
  describe ".call" do
    let(:content) { "fake-tif-binary-content" }
    let(:fixed_time) { DateTime.new(2026, 7, 25, 19, 30, 45) }
    let(:expected_filename) { "2026-07-25-19-30-45.tif" }

    before do
      allow(DateTime).to receive(:now).and_return(fixed_time)
    end

    after do
      File.delete(expected_filename) if File.exist?(expected_filename)
    end

    it "writes string content to tif file and returns readable file" do
      result = described_class.call(content)

      expect(File.read(expected_filename)).to eq content
      expect(File.read(result.path)).to eq content
    end

    it "uses datetime-based filename" do
      described_class.call(content)

      expect(File).to exist(expected_filename)
    end
  end
end
