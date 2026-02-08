# typed: false

RSpec.describe Person, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:owners).class_name("Owner") }
    it { is_expected.to have_many(:plots).through(:owners).class_name("Plot") }
  end

  describe "#full_name" do
    let(:person) { create(:person, surname: surname, first_name: first_name, middle_name: middle_name) }
    let(:surname) { "Surname" }
    let(:first_name) { "FirstName" }
    let(:middle_name) { "MiddleName" }

    it { expect(person.full_name).to eq [surname, first_name, middle_name].join(" ") }
  end

  describe "#member" do
    let(:person) { create(:person, member_from: Date.new(2024, 12, 22)) }

    it { expect(person.member).to eq "22.12.2024" }
  end

  describe "#short_name" do
    let(:person) { build(:person, first_name: "Forrest", middle_name: "Alexander", surname: "Gump") }
    it { expect(person.short_name).to eq "Gump F. A." }
  end
end
