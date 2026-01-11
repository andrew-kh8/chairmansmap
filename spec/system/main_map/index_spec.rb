require "rails_helper"

RSpec.describe "index plots", type: :system do
  let!(:plot) { create(:plot) }
  let!(:person) { create(:person) }
  let!(:owner) { create(:owner, plot: plot, person: person) }

  it "shows plot's data" do
    visit root_path

    find("path.leaflet-interactive").click

    within("turbo-frame#side_panel_plot_data") do
      expect(page).to have_content(plot.number)

      expect(page).to have_content(plot.owner_type)
      expect(page).to have_content(person.full_name)
      expect(page).to have_content(person.tel)
      expect(page).to have_content(person.address)

      expect(page).to have_content(plot.cadastral_number)
      expect(page).to have_content(plot.area)
      expect(page).to have_content(plot.perimeter.to_i)
      expect(page).to have_content(plot.sale_status)
      expect(page).to have_content(plot.description)
    end
  end
end
