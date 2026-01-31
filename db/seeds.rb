# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Plot.all.find_each do |plot|
  person = FactoryBot.create(:person)
  if plot.owners.blank?
    Owner.create(plot: plot, person: person, active_from: person.member_from)
  end
end
