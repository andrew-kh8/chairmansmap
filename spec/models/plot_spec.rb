require 'rails_helper'

RSpec.describe Plot, type: :model do
  describe "associations" do
    it { have_one(:plot_datum).dependent(:destroy).class_name("PlotDatum") }
    it { have_many(:owners).class_name("Owner") }
    it { have_one(:owner).class_name("Owner") }
    it { have_many(:persons).class_name("Person") }
    it { have_one(:person).class_name("Person") }
  end
end
