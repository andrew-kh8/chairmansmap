require 'rails_helper'

RSpec.describe 'people', type: :system do
  let!(:person) { create(:person) }

  context "when nothing to change" do
    it "does nothing" do
      #  TODO: write test pls
    end
  end
end
