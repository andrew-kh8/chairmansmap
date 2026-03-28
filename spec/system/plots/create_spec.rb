# typed: false

RSpec.describe "Plots Create", type: :system do
  let!(:person) { create(:person) }
  let(:cadaster_number) { "9:7:806:308631" }
  let(:plot_number) { 999 }
  let!(:village) { create(:village) }

  context "when coords are existed" do
    before do
      plot_coords = build(:plot).geom.coordinates.first
      expect(Geo::GetPlotCoords).to receive(:call).with(cadaster_number).and_return(Typed::Success.new(plot_coords)).twice
    end

    it "creates a new plot successfully" do
      visit new_plot_path

      fill_in "Номер участка", with: plot_number
      fill_in "Кадастровый номер", with: cadaster_number
      fill_in "Описание", with: "Test Plot"
      select person.short_name, from: "Владелец"
      select "личная собственность", from: "Тип владения"
      select "продается", from: "Статус продажи"
      select village.name, from: "Поселок"

      click_button "Проверить"
      click_button "Создать участок"

      expect(page).to have_content(plot_number)
      expect(page).to have_current_path(plot_path(Plot.last))
    end
  end

  context "when cannot get coords" do
    before do
      allow(Geo::GetPlotCoords).to receive(:call).with(cadaster_number).and_return(Typed::Failure.new("an error"))
    end

    it "fails to create plot with invalid data" do
      visit new_plot_path

      fill_in "Кадастровый номер", with: cadaster_number
      click_button "Проверить"

      expect(page).to have_current_path(new_plot_path)
    end
  end
end
