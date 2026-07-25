# typed: false

RSpec.describe Apis::OpenTopo::DemFile do
  describe "#initialize" do
    let(:original_file) { File.open(__FILE__) }

    it "stores original file and metadata" do
      dem_file = described_class.new(
        original_file: original_file,
        dem_type: "SRTMGL3",
        output_format: "GTiff"
      )

      expect(dem_file.original_file).to eq original_file
      expect(dem_file.dem_type).to eq "SRTMGL3"
      expect(dem_file.output_format).to eq "GTiff"
      expect(dem_file.csv_file).to be_nil
    end
  end

  describe "#build_csv" do
    let(:original_file) { File.open(__FILE__) }
    let(:dem_file) do
      described_class.new(
        original_file: original_file,
        dem_type: "SRTMGL3",
        output_format: "GTiff"
      )
    end
    let(:csv_path) { Tempfile.new(["dem", ".csv"]).path }

    before do
      CSV.open(csv_path, "w") do |csv|
        csv << ["x", "y", "z"]
        csv << [10.0, 20.0, 100.0]
      end

      allow(Apis::OpenTopo::Converters::TifToCsvConverter).to receive(:call)
        .with(original_file)
        .and_return(CSV.open(csv_path, "r"))
    end

    it "converts original tif file to csv" do
      csv = dem_file.build_csv
      rows = csv.read

      expect(rows).to eq [
        ["x", "y", "z"],
        ["10.0", "20.0", "100.0"]
      ]
    end

    it "memoizes csv conversion" do
      expect(Apis::OpenTopo::Converters::TifToCsvConverter).to receive(:call)
        .once
        .and_return(CSV.open(csv_path, "r"))

      dem_file.build_csv
      dem_file.build_csv
    end
  end
end
