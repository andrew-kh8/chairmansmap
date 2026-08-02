# typed: false

RSpec.describe Apis::OpenTopo::DemFile do
  let(:original_file) { File.open(__FILE__) }
  let(:dem_file) do
    described_class.new(
      original_file: original_file,
      dem_type: "SRTMGL3",
      output_format: "GTiff"
    )
  end

  describe "#initialize" do
    it "stores original file and metadata" do
      expect(dem_file.original_file).to eq original_file
      expect(dem_file.dem_type).to eq "SRTMGL3"
      expect(dem_file.output_format).to eq "GTiff"
      expect(dem_file.csv_file).to be_nil
    end
  end

  describe "#build_csv" do
    let(:converter) { Apis::OpenTopo::Converters::TifToCsvSimpleConverter }
    let(:csv_path) { Tempfile.new(["dem", ".csv"]).path }
    let(:csv_file) { CSV.open(csv_path, "r") }

    it "converts original tif file to csv" do
      expect(converter).to receive(:call).with(original_file).and_return(csv_file)
      expect(dem_file.build_csv).to eq csv_file
    end

    it "memoizes csv conversion" do
      expect(converter).to receive(:call).once.and_return(csv_file)

      dem_file.build_csv
      dem_file.build_csv
    end
  end
end
