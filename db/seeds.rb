# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Plot.all.each do |plot|
  person = FactoryBot.create(:person)
  Owner.create(plot_id: plot.number, person_id: person.id, active_from: person.member_from)

  PlotDatum.create(
    plot_id: plot.number,
    sale_status: ['не продается', 'продается'].sample,
    owner_type: ['личная собственность', 'государственная собственность'].sample,
    kadastr_number: [
        FFaker::Number.number,
        FFaker::Number.number,
        FFaker::Number.number(digits: 3),
        FFaker::Number.number(digits: 6)
      ].join(':')
  )
end
