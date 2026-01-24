RSpec.describe "Plots Index", type: :system do
  let!(:plot1) { create(:plot, number: 1, area: 100) }
  let!(:plot2) { create(:plot, number: 2, area: 200) }
  let!(:owner1) { create(:owner, plot: plot1, person: create(:person)) }
  let!(:owner2) { create(:owner, plot: plot2, person: create(:person)) }

  before { visit plots_path }

  it "shows list of plots" do
    expect(page).to have_content("№ #{plot1.number}")
    expect(page).to have_content("№ #{plot2.number}")
    expect(page).to have_content(plot1.person.short_name)
    expect(page).to have_content(plot2.person.short_name)
  end

  context "when filtering plots" do
    it "filters by area" do
      fill_in "От", with: "150"

      click_button "Применить"

      expect(page).to have_content("№ #{plot2.number}")
      expect(page).not_to have_content("№ #{plot1.number}")
    end
  end
end
