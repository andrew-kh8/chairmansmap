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

    context "when search by plot_presence" do
      let!(:person_with_plot) { create(:person) }
      let!(:person_without_plot) { create(:person) }

      before { create(:owner, person: person_with_plot, plot: create(:plot)) }

      context "when plot_presence is nil" do
        let(:plot_presence) { nil }

        it "returns all people" do
          is_expected.to match_array [person_with_plot, person_without_plot]
        end
      end

      context "when plot_presence is true" do
        let(:plot_presence) { true }

        it "returns only people with plots" do
          is_expected.to match_array [person_with_plot]
        end
      end

      context "when plot_presence is false" do
        let(:plot_presence) { false }

        it "returns only people without plots" do
          is_expected.to match_array [person_without_plot]
        end
      end
    end

    context "when search by active" do
      let!(:active_person) { create(:person) }
      let!(:discarded_person) { create(:person, :discarded) }

      context "when active is nil" do
        let(:active) { nil }

        it "returns all people" do
          is_expected.to match_array [active_person, discarded_person]
        end
      end

      context "when active is true" do
        let(:active) { true }

        it "returns only active people" do
          is_expected.to match_array [active_person]
        end
      end

      context "when active is false" do
        let(:active) { false }

        it "returns only discarded people" do
          is_expected.to match_array [discarded_person]
        end
      end
    end

    context "when sorting results" do
      let!(:alice) { create(:person, surname: "Алексеева", first_name: "Анна", middle_name: "Андреевна", member_from: 3.years.ago) }
      let!(:boris) { create(:person, surname: "Борисов", first_name: "Борис", middle_name: "Викторович", member_from: 1.year.ago) }
      let!(:viktor) { create(:person, surname: "Борисов", first_name: "Виктор", middle_name: "Борисович", member_from: 2.years.ago) }

      context "when sort is nil (default)" do
        let(:sort) { nil }

        it "returns people sorted by name ascending" do
          expect(subject.to_a).to eq [alice, boris, viktor]
        end
      end

      context "when sort is 'name_desc'" do
        let(:sort) { "name_desc" }

        it "returns people sorted by name descending" do
          expect(subject.to_a).to eq [viktor, boris, alice]
        end
      end

      context "when sort is 'member'" do
        let(:sort) { "member" }

        it "returns people sorted by member_from ascending" do
          expect(subject.to_a).to eq [alice, viktor, boris]
        end
      end

      context "when sort is 'member_desc'" do
        let(:sort) { "member_desc" }

        it "returns people sorted by member_from descending" do
          expect(subject.to_a).to eq [boris, viktor, alice]
        end
      end
    end

    context "when combining multiple filters" do
      let!(:active_person_with_plot) { create(:person, first_name: "Иван", surname: "Иванов") }
      let!(:active_person_without_plot) { create(:person, first_name: "Петр", surname: "Петров") }
      let!(:discarded_person_with_plot) { create(:person, :discarded, first_name: "Сидор", surname: "Сидоров") }
      let!(:plot1) { create(:plot) }
      let!(:plot2) { create(:plot) }
      let!(:owner1) { create(:owner, person: active_person_with_plot, plot: plot1) }
      let!(:owner2) { create(:owner, person: discarded_person_with_plot, plot: plot2) }

      context "when filtering by active=true and plot_presence=true" do
        let(:active) { true }
        let(:plot_presence) { true }

        it "returns only active people with plots" do
          is_expected.to match_array [active_person_with_plot]
        end
      end

      context "when filtering by full_name and active=true" do
        let(:full_name) { "Иван" }
        let(:active) { true }

        it "returns matching active people" do
          is_expected.to match_array [active_person_with_plot]
        end
      end

      context "when filtering by full_name and plot_presence=false" do
        let(:full_name) { "Петр" }
        let(:plot_presence) { false }

        it "returns matching people without plots" do
          is_expected.to match_array [active_person_without_plot]
        end
      end
    end
  end
end
