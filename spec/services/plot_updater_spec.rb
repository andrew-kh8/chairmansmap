require "rails_helper"

RSpec.describe PlotUpdater do
  subject(:result) { described_class.new.call(plot_id, person_id, plot_data) }

  let(:person) { create(:person) }
  let(:plot) { create(:plot) }
  let!(:plot_datum) { create(:plot_datum, plot: plot, kadastr_number: "1:2:3:4") }

  describe "#call" do
    context "when result is positive" do
      let(:plot_id) { plot.id }
      let(:person_id) { person.id }
      let(:plot_data) { {sale_status: "продается", owner_type: "личная собственность", description: description} }
      let(:description) { "описание" }

      it "updates plot data" do
        expect { result }.to change { plot_datum.reload.sale_status }.to("for_sale")
          .and change { plot_datum.owner_type }.to("personal")
          .and change { plot_datum.description }.to(description)
          .and not_change { plot_datum.kadastr_number }
          .and change { plot.owners.count }.by(1)

        expect(result).to eq Dry::Monads::Success(plot)
      end

      context "when person_id is nil" do
        let(:person_id) { nil }

        it "updates plot data" do
          expect { result }.to change { plot_datum.reload.sale_status }.to("for_sale")
            .and change { plot_datum.owner_type }.to("personal")
            .and change { plot_datum.description }.to(description)
            .and not_change { plot_datum.kadastr_number }
            .and not_change { plot.owners.count }

          expect(result).to eq Dry::Monads::Success(plot)
        end
      end

      context "when plot_data is nil" do
        let(:plot_data) { nil }

        it "updates plot data" do
          expect { result }.to not_change { plot_datum.reload.sale_status }
            .and not_change { plot_datum.owner_type }
            .and not_change { plot_datum.description }
            .and not_change { plot_datum.kadastr_number }
            .and change { plot.owners.count }.by(1)

          expect(result).to eq Dry::Monads::Success(plot)
        end
      end
    end

    context "when result is negative" do
      context "when plot not found" do
        let(:plot_id) { 0 }
        let(:person_id) { person.id }
        let(:plot_data) { {} }
        let(:failure_text) { "Не получилось найти участок" }

        it "raise an error" do
          expect { result }.to not_change { plot_datum }.and(not_change { plot })

          expect(result).to eq Dry::Monads::Failure(failure_text)
        end
      end

      context "when person id is invalid" do
        let(:plot_id) { plot.id }
        let(:person_id) { 0 }
        let(:plot_data) { {} }
        let(:failure_text) { "При обновлении данных произошла ошибка. Validation failed: Person must exist" }

        it "raise an error" do
          expect { result }.to not_change { plot_datum }
            .and not_change { plot }

          expect(result).to eq Dry::Monads::Failure(failure_text)
        end
      end

      context "when plot data is invalid" do
        let(:plot_id) { plot.id }
        let(:person_id) { person.id }
        let(:plot_data) { {sale_status: "invalid status"} }
        let(:failure_text) { "При обновлении данных произошла ошибка. 'invalid status' is not a valid sale_status" }

        it "raise an error" do
          expect { result }.to not_change { plot_datum }
            .and not_change { plot }

          expect(result).to eq Dry::Monads::Failure(failure_text)
        end
      end
    end
  end
end
