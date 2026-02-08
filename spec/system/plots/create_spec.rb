# typed: false

RSpec.describe "Plots Create", type: :system do
  let!(:person) { create(:person) }
  let(:cadaster_number) { "9:7:806:308631" }
  let(:plot_number) { 999 }

  context "when coords are existed" do
    before do
      plot_coords = build(:plot).geom.coordinates.first.first
      allow(Geo::GetPlotCoords).to receive(:call).with(cadaster_number).and_return(DM::Success(plot_coords))
    end

    it "creates a new plot successfully" do
      visit new_plot_path

      fill_in "Номер участка", with: plot_number
      fill_in "Кадастровый номер", with: cadaster_number
      fill_in "Описание", with: "Test Plot"
      select person.short_name, from: "Владелец"
      select "личная собственность", from: "Тип владения"
      select "продается", from: "Статус продажи"

      click_button "Проверить"
      click_button "Создать участок"

      expect(page).to have_content(plot_number)
      expect(page).to have_current_path(plot_path(Plot.last))
    end
  end

  context "when cannot get coords" do
    before do
      allow(Geo::GetPlotCoords).to receive(:call).with(cadaster_number).and_return(DM::Failure("an error"))
    end

    it "fails to create plot with invalid data" do
      visit new_plot_path

      fill_in "Кадастровый номер", with: cadaster_number
      click_button "Проверить"

      expect(page).to have_current_path(new_plot_path)
    end
  end
end
