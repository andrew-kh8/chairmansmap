# typed: false

RSpec.describe PlotGeometry do
  subject { described_class.call(plot_ids:, village_id:) }

  let(:plot_ids) { nil }
  let(:village_id) { nil }

  describe ".call" do
    context "when plot_ids parameter is nil" do
      context "when there are plots" do
        let!(:plot1) { create(:plot) }
        let!(:plot2) { create(:plot) }
        let!(:plot3) { create(:plot) }

        it "returns all plots" do
          expect(subject.size).to eq(3)
          expect(subject.map(&:id)).to match_array([plot1.id, plot2.id, plot3.id])
          expect(subject.map(&:number)).to match_array([plot1.number, plot2.number, plot3.number])
        end
      end

      context "when there are no plots" do
        it "returns an empty array" do
          expect(subject).to eq([])
        end
      end
    end

    context "when plot_ids parameter is provided" do
      let!(:plot1) { create(:plot) }
      let!(:plot2) { create(:plot) }
      let!(:plot3) { create(:plot) }

      context "when filtering by specific plot_ids" do
        let(:plot_ids) { [plot1.id, plot3.id] }

        it "returns only specified plots" do
          expect(subject.size).to eq(2)
          expect(subject.map(&:id)).to match_array([plot1.id, plot3.id])
        end
      end

      context "when filtering by single plot_id" do
        let(:plot_ids) { [plot2.id] }
        let(:first_plot) { subject.first }

        it "returns array with one plot" do
          expect(subject.size).to eq(1)
          expect(first_plot.id).to eq(plot2.id)
        end
      end

      context "when filtering by empty array" do
        let(:plot_ids) { [] }

        it "returns all plots (empty array is present?)" do
          expect(subject.size).to eq(3)
        end
      end

      context "when filtering by non-existent plot_ids" do
        let(:plot_ids) { [99999, 88888] }

        it "returns empty array" do
          expect(subject).to eq([])
        end
      end
    end

    context "when village_id parameter is provided" do
      let(:village) { create(:village) }
      let(:village_id) { village.id }
      let!(:plot1) { create(:plot, village:) }
      let!(:plot2) { create(:plot, village:) }
      let!(:plot3) { create(:plot) }

      it "returns only specified plots" do
        expect(subject.size).to eq(2)
        expect(subject.map(&:id)).to match_array([plot1.id, plot2.id])
      end
    end
  end
end
