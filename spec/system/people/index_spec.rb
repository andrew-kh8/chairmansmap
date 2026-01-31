RSpec.describe "People Index", type: :system do
  let!(:active_person) { create(:person, first_name: "Ivan", surname: "Active") }
  let!(:archived_person) { create(:person, :discarded, first_name: "Petr", surname: "Archived") }

  before { visit people_path }

  it "shows list of people" do
    expect(page).to have_content(active_person.full_name)
    expect(page).to have_content(archived_person.full_name)
  end

  context "when searching by name" do
    it "filters people" do
      fill_in "ФИО...", with: "Ivan"
      click_button "Поиск"

      expect(page).to have_content(active_person.full_name)
      expect(page).not_to have_content(archived_person.full_name)
    end
  end

  context "when filtering by status" do
    it "shows only active people" do
      choose "Активные" # Label text
      click_button "Поиск"

      expect(page).to have_content(active_person.full_name)
      expect(page).not_to have_content(archived_person.full_name)
    end
  end
end
