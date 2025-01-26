require 'rails_helper'

RSpec.describe 'show plots', type: :system do
  let(:plot) { Plot.find(1) }
  let!(:person) { create(:person) }
  let!(:plot_datum) { create(:plot_datum, plot: plot) }
  let!(:owner) { create(:owner, plot: plot, person: person) }

  it "shows plot's data" do
    visit root_path

    expect(find_by_id('plot_number', visible: false)).to have_no_css('*')

    find('path', match: :first).click

    expect(find_by_id('plot_number')).to have_content(plot.number)

    expect(find_by_id('owner_type')).to have_content(plot_datum.owner_type)
    expect(find_by_id('owner_fio')).to have_content(person.full_name)
    expect(find_by_id('owner_tel')).to have_content(person.tel)
    expect(find_by_id('owner_adr')).to have_content(person.address)

    expect(find_by_id('plot_number_kadastr')).to have_content(plot_datum.kadastr_number)
    expect(find_by_id('plot_area')).to have_content(plot.area)
    expect(find_by_id('plot_perimetr')).to have_content(plot.perimetr.to_i)
    expect(find_by_id('plot_sale_status')).to have_content(plot_datum.sale_status)
    expect(find_by_id('plot_description')).to have_content(plot_datum.description)
  end
end
