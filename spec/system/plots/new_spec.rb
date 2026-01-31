RSpec.describe "Plots New", type: :system do
  let!(:person) { create(:person) }
  let(:cadaster_number) { "9:7:806:308631" }
  let(:plot_number) { 999 }

  it "shows form" do
    visit new_plot_path

    expect(page).to have_field "Номер участка"
    expect(page).to have_field "Кадастровый номер"
    expect(page).to have_field "Описание"
    expect(page).to have_field "Владелец"
    expect(page).to have_field "Тип владения"
    expect(page).to have_field "Статус продажи"
  end
end
