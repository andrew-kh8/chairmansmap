require "rails_helper"

RSpec.describe PeopleSearch do
  subject { described_class.call(filters) }
  describe ".call" do
    let(:filters) { {full_name:, plot_presence:, active:, sort:} }
    let(:full_name) { nil }
    let(:plot_presence) { nil }
    let(:active) { nil }
    let(:sort) { nil }

    context "when search by full_name" do
      let!(:gump) { create(:person, first_name: "Forrest", surname: "Gump") }
      let!(:bubba) { create(:person, first_name: "Benjamin", surname: "Buford") }

      context "when search_string is empty" do
        it "returns all people" do
          is_expected.to match_array [gump, bubba]
        end
      end

      context "when find by first_name" do
        let(:full_name) { gump.first_name }
        it "returns person by first_name" do
          is_expected.to match_array [gump]
        end
      end

      context "when find by part of first_name" do
        let(:full_name) { gump.first_name[..4] }
        it "returns person by part of first_name" do
          is_expected.to match_array [gump]
        end
      end

      context "when find by part of surname and first_name" do
        let(:full_name) { [gump.surname, gump.first_name[..4]].join(" ") }
        it "returns person by part of surname and first_name" do
          is_expected.to match_array [gump]
        end
      end
    end
  end
end
