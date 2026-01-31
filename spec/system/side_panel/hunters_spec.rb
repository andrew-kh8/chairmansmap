RSpec.describe "SidePanel::Hunters", type: :system do
  let!(:hunter_location) { create(:hunter_location, location: "POINT(10 10)") }

  it "shows list of hunters" do
    visit root_path
    click_link "Охотники"

    within "#side_panel" do
      expect(page).to have_content(hunter_location.description)
    end
  end

  it "creates a new hunter location" do
    visit root_path
    click_link "Охотники"

    within "#side_panel" do
      click_link "Добавить"

      fill_in "Локация", with: "10 20"
      fill_in "Описание", with: "New Description"
      check "Лицензия"
      check "Собака"

      click_button "Сохранить"

      expect(page).to have_content("New Description")
      expect(page).to have_link("Добавить")
    end
  end

  context "when filter" do
    let!(:hunter_location_match) { create(:hunter_location, dog: true) }
    let!(:another_hunter_location) { create(:hunter_location, dog: false) }

    it "filters hunters" do
      visit root_path
      click_link "Охотники"

      within "#side_panel" do
        select "есть", from: "Собака"
        click_button "Фильтровать"

        expect(page).to have_content(hunter_location_match.description)
        expect(page).not_to have_content(another_hunter_location.description)
      end
    end
  end
end
