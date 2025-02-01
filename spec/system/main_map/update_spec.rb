require 'rails_helper'

RSpec.describe 'update plots', type: :system do
  let(:plot) { Plot.find(1) }
  let!(:new_person) { create(:person) }
  let!(:plot_datum) { create(:plot_datum, plot: plot) }
  let!(:owner) { create(:owner, plot: plot) }

  it "update plot's data" do
    visit root_path

    expect(find_by_id('plot_number', visible: false)).to have_no_css('*')

    find('path', match: :first).click

    expect(find_by_id('plot_number')).to have_content(plot.number)

    click_button('Обновить данные участка')
    select(new_person.full_name, from: 'Владелец участка')
    select('продается', from: 'Статус продажи')
    select('личная собственность', from: 'Тип владения')
    fill_in('form_description',	with: 'Дополнительная информация')

    click_button('Обновить')

    expect(find_by_id('plot_number')).to have_content(plot.number)

    expect(find_by_id('owner_type')).to have_content(plot_datum.reload.owner_type)
    expect(find_by_id('owner_fio')).to have_content(new_person.full_name)
    expect(find_by_id('owner_tel')).to have_content(new_person.tel)
    expect(find_by_id('owner_adr')).to have_content(new_person.address)

    expect(find_by_id('plot_number_kadastr')).to have_content(plot_datum.reload.kadastr_number)
    expect(find_by_id('plot_area')).to have_content(plot.area)
    expect(find_by_id('plot_perimetr')).to have_content(plot.perimetr.to_i)
    expect(find_by_id('plot_sale_status')).to have_content(plot_datum.reload.sale_status)
    expect(find_by_id('plot_description')).to have_content(plot_datum.reload.description)
  end
end
