require "rails_helper"

RSpec.describe "people", type: :system do
  let!(:person) { create(:person) }

  context "when there is one active person" do
    it "shows one person" do
      visit people_path

      expect(page).to have_content("Новый участок")

      expect(page).to have_content(person.full_name)
        .and have_content(person.tel)
        .and have_content(person.address)
        .and have_content(person.member)
    end
  end

  context "when there is a archived participant" do
    let!(:archived_person) { create(:person, :discarded) }

    it "shows a archived participant in second tab" do
      visit people_path

      expect(page).to have_content("Новый участок")

      expect(page).to have_content(person.full_name)
      expect(page).to have_content(archived_person.full_name)

      find("label", text: "Активные").click
      click_button "Поиск"

      expect(page).to have_content(person.full_name)
      expect(page).not_to have_content(archived_person.full_name)

      find("label", text: "Архивные").click
      click_button "Поиск"

      expect(page).not_to have_content(person.full_name)
      expect(page).to have_content(archived_person.full_name)
    end
  end
end
