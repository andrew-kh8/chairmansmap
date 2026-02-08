# typed: false

RSpec.describe "plots", type: :system do
  let(:person) { create(:person) }
  let(:plot) { create(:plot) }
  let!(:owner) { create(:owner, plot:, person:) }

  it "show plot's data" do
    visit plot_path(plot)

    expect(page).to have_content(person.full_name)
    expect(page).to have_content(plot.cadastral_number)
    expect(page).to have_content(plot.owner_type)
    expect(page).to have_content(plot.sale_status)
  end
end
