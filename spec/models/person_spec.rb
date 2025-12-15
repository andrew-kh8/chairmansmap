require "rails_helper"

RSpec.describe Person, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:owners).class_name("Owner") }
    it { is_expected.to have_many(:plots).class_name("Plot") }
  end

  # deprecated with PeopleSearch
  describe "by_full_name" do
    subject { described_class.by_full_name(search_string) }

    let!(:gump) { create(:person, first_name: "Forrest", surname: "Gump") }
    let!(:bubba) { create(:person, first_name: "Benjamin", surname: "Buford") }

    context "when search_string is empty" do
      let(:search_string) { nil }
      it { is_expected.to match_array [gump, bubba] }
    end

    context "when find by first_name" do
      let(:search_string) { gump.first_name }
      it { is_expected.to match_array [gump] }
    end

    context "when find by part of first_name" do
      let(:search_string) { gump.first_name[..4] }
      it { is_expected.to match_array [gump] }
    end

    context "when find by part of surname and first_name" do
      let(:search_string) { [gump.surname, gump.first_name[..4]].join(" ") }
      it { is_expected.to match_array [gump] }
    end
  end

  describe "full_name" do
    let(:full_name) { create(:person, surname: surname, first_name: first_name, middle_name: middle_name).full_name }
    let(:surname) { "Surname" }
    let(:first_name) { "FirstName" }
    let(:middle_name) { "MiddleName" }

    it { expect(full_name).to eq [surname, first_name, middle_name].join(" ") }
  end

  describe "member" do
    let(:member) { create(:person, member_from: Date.new(2024, 12, 22)).member }

    it { expect(member).to eq "22.12.2024" }
  end
end
