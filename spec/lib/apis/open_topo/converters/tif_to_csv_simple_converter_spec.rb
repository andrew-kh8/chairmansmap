# typed: false

RSpec.describe Apis::OpenTopo::Converters::TifToCsvSimpleConverter do
  subject { described_class.call(sample_tif, csv_path: csv_output_path) }

  let(:sample_tif_path) { Rails.root.join("spec/fixtures/files/open_topo/graffham_test.tif") }
  let(:sample_tif) { File.open(sample_tif_path) }
  let(:csv_output_path) { Rails.root.join("spec/fixtures/files/open_topo/tif_to_csv_converter_output.csv") }

  after do
    File.delete(csv_output_path) if csv_output_path.present? && File.exist?(csv_output_path)
  end

  describe ".call" do
    context "when tif file is valid" do
      let(:expected_csv_path) { Rails.root.join("spec/fixtures/files/open_topo/graffham_test.csv") }

      it "creates csv with geo coordinates and elevation values" do
        expect(FileUtils.compare_file(subject.path, expected_csv_path)).to be_truthy
      end

      it "writes csv file next to tif basename" do
        subject

        expect(File).to exist(csv_output_path)
      end
    end

    context "when tif file not exists" do
      let(:invalid_file) { instance_double(File, path: "/nonexistent/open_topo/sample.tif") }

      it "raises error" do
        expect { described_class.call(invalid_file) }.to raise_error(Apis::OpenTopo::Errors::ConvertError)
          .with_message("ERROR 4: /nonexistent/open_topo/sample.tif: No such file or directory")
      end
    end
  end
end
