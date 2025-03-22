# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Owner, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:plot).class_name('Plot') }
    it { is_expected.to belong_to(:person).class_name('Person') }
    it { is_expected.to have_one(:plot_datum).class_name('PlotDatum') }
  end

  describe 'validations' do
    subject { create(:owner, active_to: active_to) }

    context 'when owner is active' do
      let(:active_to) { Date.current }

      it 'validates' do
        allow(subject.active_to?).to be true
        expect(subject).to validate_uniqueness_of(:plot_id).scoped_to(:active_to).ignoring_case_sensitivity
      end
    end

    context "when owner isn't active" do
      let(:active_to) { nil }

      it "doesn't validate" do
        allow(subject.active_to?).to be false
        expect(subject).not_to validate_uniqueness_of(:plot_id).scoped_to(:active_to)
      end
    end
  end
end
