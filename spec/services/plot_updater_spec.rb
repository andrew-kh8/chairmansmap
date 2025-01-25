require "rails_helper"

RSpec.describe PlotUpdater do
  subject { described_class.new.call(plot_id, person_id, plot_data) }
  
  let(:person) {create(:person) }
  let(:plot) { create(:plot) }
  let!(:plot_datum) { create(:plot_datum, plot: plot, kadastr_number: "1:2:3:4") }

  describe "#call" do
    context "positive" do
      let(:plot_id) { plot.id }
      let(:person_id) { person.id }
      let(:plot_data) { {sale_status: "продается", owner_type: "личная собственность", description: description} }
      let(:description) { "описание" }

      it "updates plot data" do
        expect { subject }.to change { plot_datum.reload.sale_status }.to("for_sale")
          .and change { plot_datum.owner_type }.to("personal")
          .and change { plot_datum.description }.to(description)
          .and not_change { plot_datum.kadastr_number }
        expect(subject).to eq Dry::Monads::Success(plot)
      end
    end

    context "negative" do
      context "when plot not found" do
        let(:plot_id) { 0 }
        let(:person_id) { person.id }
        let(:plot_data) { {} }

        it "raise an error" do
          expect { subject }.to not_change { plot_datum }
            .and not_change { plot }
          expect(subject).to eq Dry::Monads::Failure("Не получилось найти участок")
        end
      end

      context "when person id is invalid" do
        let(:plot_id) { plot.id }
        let(:person_id) { 0 }
        let(:plot_data) { {} }

        it "raise an error" do
          expect { subject }.to not_change { plot_datum }
            .and not_change { plot }
          expect(subject).to eq Dry::Monads::Failure("При обновлении данных произошла ошибка. Validation failed: Person must exist")
        end

      end

      context "when plot data is invalid" do
        let(:plot_id) { plot.id }
        let(:person_id) { person.id }
        let(:plot_data) { {sale_status: "invalid status"} }

        it "raise an error" do
          expect { subject }.to not_change { plot_datum }
            .and not_change { plot }
          expect(subject).to eq Dry::Monads::Failure("При обновлении данных произошла ошибка. 'invalid status' is not a valid sale_status")
        end
      end
    end
  end
end
