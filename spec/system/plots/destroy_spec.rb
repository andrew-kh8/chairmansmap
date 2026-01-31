RSpec.describe "Plots Destroy", type: :system do
  let(:plot) { create(:plot) }
  let!(:owner) { create(:owner, plot: plot, person: create(:person)) }

  it "deletes a plot" do
    visit plot_path(plot)

    accept_confirm do
      click_button "Удалить участок и все записи о нем"
    end

    expect(page).to have_content("Участок #{plot.id} удален")
    expect(page).to have_current_path(plots_path)
  end
end
