require "rails_helper"

RSpec.describe Owner, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:plot).class_name("Plot") }
    it { is_expected.to belong_to(:person).class_name("Person") }
    it { is_expected.to have_one(:plot_datum).class_name("PlotDatum") }
  end

  describe "validations" do
    subject { create(:owner) }

    context "when owner is active" do
      it "validates" do
        allow(subject).to receive(:active_to?).and_return(true)
        expect(subject).to validate_uniqueness_of(:plot_id).scoped_to(:active_to).ignoring_case_sensitivity
      end
    end

    context "when owner isn't active" do
      it "doesn't validate" do
        allow(subject).to receive(:active_to?).and_return(false)
        expect(subject).not_to validate_uniqueness_of(:plot_id).scoped_to(:active_to)
      end
    end
  end
end
