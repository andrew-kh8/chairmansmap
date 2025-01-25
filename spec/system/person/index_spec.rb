require 'rails_helper'

RSpec.describe "people", type: :system do
  let!(:person) { create(:person) }

  context "when there is one active person" do
    
    it "shows one person" do
      visit person_index_path

      expect(page).to have_content("Активные участники (1)")
      expect(page).to have_content("Бывшие участники (0)")
      expect(page).to have_content("Все участники (1)")

      expect(page).to have_content(person.full_name)
        .and have_content(person.tel)
        .and have_content(person.address)
        .and have_content(person.member)

      find("label", text: "Бывшие участники (0)").click

      expect(find("tbody", visible: false)).to have_no_css("*")
    end
  end

  context "when there is a former participant" do
    let!(:former_person) { create(:person, :discarded) }

    it "shows a former participant in second tab" do
      visit person_index_path

      expect(page).to have_content("Активные участники (1)")
      expect(page).to have_content("Бывшие участники (1)")
      expect(page).to have_content("Все участники (2)")

      expect(page).to have_content(person.full_name)
      .and have_content(person.tel)
      .and have_content(person.address)
      .and have_content(person.member)

      find("label", text: "Бывшие участники (1)").click

      expect(page).to have_content(former_person.full_name)
      .and have_content(former_person.tel)
      .and have_content(former_person.address)
      .and have_content(former_person.member)

      find("label", text: "Все участники (2)").click

      expect(page).to have_content(person.full_name)
      .and have_content(person.tel)
      .and have_content(person.address)
      .and have_content(person.member)
      expect(page).to have_content(former_person.full_name)
      .and have_content(former_person.tel)
      .and have_content(former_person.address)
      .and have_content(former_person.member)
    end
  end
end
