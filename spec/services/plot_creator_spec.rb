require "rails_helper"

RSpec.describe PlotCreator do
  subject { described_class.new(params).call }

  let(:person) { create(:person) }
  let(:plot_number) { 123 }
  let(:cadastral_number) { "11:22:33:44" }
  let(:params) do
    {
      number: plot_number,
      description: "Test Plot",
      sale_status: "for_sale",
      owner_type: "personal",
      cadastral_number: "11:22:33:44",
      person_id: person.id
    }
  end
  let(:coords) { [[0, 0], [10, 0], [0, 10], [0, 0]] }

  describe "#call" do
    before { allow(Geo::GetPlotCoords).to receive(:call).with(cadastral_number).and_return(Dry::Monads::Success(coords)) }

    context "when plot is created" do
      it "creates plot and owner and returns Success" do
        expect { subject }.to change(Plot, :count).by(1)
          .and change(Owner, :count).by(1)

        expect(subject).to be_success
      end
    end

    context "when cannot to get plot's coords" do
      before do
        allow(Geo::GetPlotCoords).to receive(:call).with(cadastral_number).and_return(Dry::Monads::Failure("an error"))
      end

      it "returns Failure due to validation errors (empty plot)" do
        expect(subject).to be_failure
        expect(subject.failure).to include("Number can't be blank")
      end
    end

    context "when coords are invalid" do
      let(:coords) { [[0, 0], [10, 0], [0, 10]] }

      it "returns failure" do
        expect(subject).to be_failure
        expect(subject.failure).to include("Number can't be blank")
      end
    end

    context "when plot number already taken" do
      before { create(:plot, number: plot_number) }

      it "returns failure" do
        expect(subject).to be_failure
        expect(subject.failure).to include("duplicate key value violates unique constraint \"index_plots_on_number\"")
      end
    end

    context "when plot number is invalid" do
      let(:plot_number) { nil }

      it "returns failure" do
        expect(subject).to be_failure
        expect(subject.failure).to match_array(["Number can't be blank", "Number is not a number"])
      end
    end
  end
end
