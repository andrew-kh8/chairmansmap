require 'rails_helper'

RSpec.describe Person, type: :model do
  describe "associations" do
    it { should have_many(:owners).class_name("Owner") }
    it { should have_many(:plots).class_name("Plot") }
  end

  describe "full_name" do
    subject { create(:person, surname: surname, first_name: first_name, middle_name: middle_name).full_name }

    let(:surname) { "Surname" }
    let(:first_name) { "FirstName" }
    let(:middle_name) { "MiddleName" }

    it { expect(subject).to eq [surname, first_name, middle_name].join(" ")}
  end

  describe "member" do
    subject { create(:person, member_from: Date.new(2024, 12, 22)).member }
    it { expect(subject).to eq "22.12.2024" }
  end
end
