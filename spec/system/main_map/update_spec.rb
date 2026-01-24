require "rails_helper"

RSpec.describe "update plots", type: :system do
  let(:plot) { create(:plot) }
  let!(:new_person) { create(:person) }
  let!(:owner) { create(:owner, plot: plot) }

  it "update plot's data" do
    visit root_path

    find("path.leaflet-interactive").click

    within("turbo-frame#side_panel_plot_data") do
      expect(page).to have_content(plot.number)

      click_on("Обновить данные участка")
      select(new_person.full_name, from: "Владелец участка")
      select("продается", from: "Статус продажи")
      select("личная собственность", from: "Тип владения")
      fill_in("Дополнительная информация", with: "Дополнительная информация")

      click_button("Обновить")

      expect(page).to have_content(plot.number)

      expect(page).to have_content(plot.reload.owner_type)
      expect(page).to have_content(new_person.full_name)
      expect(page).to have_content(new_person.tel)
      expect(page).to have_content(new_person.address)

      expect(page).to have_content(plot.reload.cadastral_number)
      expect(page).to have_content(plot.area)
      expect(page).to have_content(plot.perimeter.to_i)
      expect(page).to have_content(plot.reload.sale_status)
      expect(page).to have_content(plot.reload.description)
    end
  end
end
