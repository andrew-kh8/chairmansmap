require 'rails_helper'

RSpec.describe PlotDatum, type: :model do
  describe "associations" do
    it { should belong_to(:plot).class_name("Plot") }
  end
end
