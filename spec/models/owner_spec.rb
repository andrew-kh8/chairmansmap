require "rails_helper"

RSpec.describe Owner, type: :model do
  describe "associations" do
    it { should belong_to(:plot).class_name("Plot") }
    it { should belong_to(:person).class_name("Person") }
    it { should have_one(:plot_datum).class_name("PlotDatum") }
  end

  describe "validations" do
    subject { create(:owner) }
    context "when owner is active" do
      before { allow(subject).to receive(:active_to?).and_return(true) }
      it { should validate_uniqueness_of(:plot_id).scoped_to(:active_to).ignoring_case_sensitivity }
    end

    context "when owner isn't active" do
      before { allow(subject).to receive(:active_to?).and_return(false) }
      it { should_not validate_uniqueness_of(:plot_id).scoped_to(:active_to) }
    end
  end
end
