# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Plot, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:plot_datum).dependent(:destroy).class_name('PlotDatum') }
    it { is_expected.to have_many(:owners).class_name('Owner') }
    it { is_expected.to have_one(:owner).class_name('Owner') }
    it { is_expected.to have_many(:persons).class_name('Person') }
    it { is_expected.to have_one(:person).class_name('Person') }
  end
end
