RSpec.describe "People Show", type: :system do
  let!(:person) { create(:person, first_name: "John", surname: "Doe", tel: "+1234567890", address: "Main St, 1") }
  let!(:plot) { create(:plot, number: 100) }
  let!(:owner) { create(:owner, person: person, plot: plot) }

  before { visit person_path(person) }

  it "shows person details" do
    expect(page).to have_content("Doe John")
    expect(page).to have_content("+1234567890")
    expect(page).to have_content("Main St, 1")
  end

  it "shows associated plots" do
    expect(page).to have_content("№#{plot.number}")
  end

  it "has edit link" do
    expect(page).to have_link("Редактировать профиль", href: edit_person_path(person))
  end
end
