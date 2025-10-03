require 'rails_helper'

RSpec.describe 'people', type: :system do
  let!(:person) { create(:person) }

  context "when nothing to change" do
    it "does nothing" do
      visit edit_person_path(person)
      # TODO: add some specs pls
    end
  end
end
