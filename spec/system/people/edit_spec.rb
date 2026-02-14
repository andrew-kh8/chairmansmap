# typed: false

RSpec.describe "People Edit", type: :system do
  let!(:person) { create(:person, first_name: "Original", surname: "Name") }

  it "show form to update person profile" do
    visit edit_person_path(person)

    expect(page).to have_field "Имя", with: person.first_name
    expect(page).to have_field "Фамилия", with: person.surname
    expect(page).to have_field "Отчество", with: person.middle_name
    expect(page).to have_field "Телефон", with: person.tel
    expect(page).to have_field "Адрес", with: person.address

    fill_in "Имя", with: "Updated"
    fill_in "Фамилия", with: "Surname"
    fill_in "Телефон", with: "999-999"
    fill_in "Адрес", with: "New Address"

    click_button "Сохранить изменения"
  end
end
