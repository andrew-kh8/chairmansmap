# typed: false

require "rails_helper"

RSpec.describe PlotCoordsUpdater do
  subject { described_class.call(plot) }

  let(:plot) { create(:plot, cadastral_number: "11:22:33:44") }

  describe ".call" do
    context "when GetPlotCoords and MultiPolygonCreator succeed" do
      let(:coords) { [[[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]]] }

      before { allow(Geo::GetPlotCoords).to receive(:call).with(plot.cadastral_number).and_return(Typed::Success.new(coords)) }

      it "updates the plot geom and returns Success" do
        expect { subject }.to change { plot.reload.geom }
          .and change { plot.area }.to(100)
          .and change { plot.perimeter }.to(40)

        expect(subject).to be_success
        expect(subject.payload).to eq plot
      end
    end

    context "when MultiPolygonCreator fails" do
      let(:coords) { [[[0, 0], [10, 0]]] }

      before { allow(Geo::GetPlotCoords).to receive(:call).with(plot.cadastral_number).and_return(Typed::Success.new(coords)) }

      it "returns Failure" do
        expect { subject }.to not_change { plot.reload.geom }

        expect(subject).to be_failure
        expect(subject.error).to eq "The coordinates are not closed in a circle"
      end
    end
  end
end
