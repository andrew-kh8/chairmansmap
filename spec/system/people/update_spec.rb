# typed: false

RSpec.describe "Update Person", type: :system do
  let!(:person) { create(:person) }

  let(:new_first_name) { "ИмяИмя" }
  let(:new_surname) { "ФамилияФамилия" }
  let(:new_middle_name) { "ОтчествоОтчество" }
  let(:new_tel) { "999-999" }
  let(:new_address) { "Адрес Адрес" }

  it "show form to update person profile" do
    visit edit_person_path(person)

    fill_in "Имя", with: new_first_name
    fill_in "Фамилия", with: new_surname
    fill_in "Отчество", with: new_middle_name
    fill_in "Телефон", with: new_tel
    fill_in "Адрес", with: new_address

    click_button "Сохранить изменения"

    expect(page).to have_current_path(person_path(person))

    expect(page).to have_content new_first_name
    expect(page).to have_content new_surname
    expect(page).to have_content new_middle_name
    expect(page).to have_content new_tel
    expect(page).to have_content new_address
  end
end
