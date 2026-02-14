# typed: false

RSpec.describe PlotSearch do
  describe "#call" do
    subject { described_class.new.call(filters).to_a }

    let(:filters) do
      {
        people:,
        area_min:,
        area_max:,
        owner_type:,
        sale_status:
      }
    end
    let(:people) { nil }
    let(:area_min) { nil }
    let(:area_max) { nil }
    let(:owner_type) { nil }
    let(:sale_status) { nil }

    context "when filters are blank" do
      let!(:plot1) { create(:plot, number: 1) }
      let!(:plot2) { create(:plot, number: 2) }
      let!(:plot3) { create(:plot, number: 3) }

      it "returns all plots sorted by number" do
        is_expected.to eq [plot1, plot2, plot3]
      end
    end

    context "when filter by_area" do
      let!(:plot1) { create(:plot, number: 1, area: 100) }
      let!(:plot2) { create(:plot, number: 2, area: 200) }
      let!(:plot3) { create(:plot, number: 3, area: 300) }
      let(:area_min) { 101 }
      let(:area_max) { 202 }

      it "returns only one plot" do
        is_expected.to eq [plot2]
      end

      context "when max area is empty" do
        let(:area_max) { nil }

        it "returns two plots" do
          is_expected.to eq [plot2, plot3]
        end
      end

      context "when min area is empty" do
        let(:area_min) { nil }

        it "returns two plots" do
          is_expected.to eq [plot1, plot2]
        end
      end
    end

    context "when filter by_person" do
      let!(:person1) { create(:person) }
      let!(:person2) { create(:person) }
      let!(:plot_with_person1) { create(:plot, number: 10) }
      let!(:plot_with_person2) { create(:plot, number: 11) }
      let!(:plot_without_person) { create(:plot, number: 12) }

      before do
        create(:owner, person: person1, plot: plot_with_person1)
        create(:owner, person: person2, plot: plot_with_person2)
      end

      context "when people filter is 'any'" do
        let(:people) { ["any"] }

        it "returns only plots with associated person" do
          is_expected.to match_array [plot_with_person1, plot_with_person2]
        end
      end

      context "when people filter is 'none'" do
        let(:people) { ["none"] }

        it "returns only plots without associated person" do
          is_expected.to match_array [plot_without_person]
        end
      end

      context "when people filter contains specific person IDs" do
        let(:people) { [person1.id] }

        it "returns only plots owned by specified person" do
          is_expected.to match_array [plot_with_person1]
        end
      end

      context "when people filter contains multiple person IDs" do
        let(:people) { [person1.id, person2.id] }

        it "returns plots owned by any of specified people" do
          is_expected.to match_array [plot_with_person1, plot_with_person2]
        end
      end
    end

    context "when filter by_owner_type" do
      let!(:private_plot) { create(:plot, owner_type: "личная собственность") }
      let!(:state_plot) { create(:plot, owner_type: "государственная собственность") }

      context "when owner_type is blank" do
        it "returns all plots" do
          is_expected.to match_array [private_plot, state_plot]
        end
      end

      context "when owner_type is specified" do
        let(:owner_type) { "личная собственность" }

        it "returns only plots with matching owner_type" do
          is_expected.to match_array [private_plot]
        end
      end
    end

    context "when filter by_sale_status" do
      let!(:for_sale_plot) { create(:plot, sale_status: "продается") }
      let!(:not_for_sale_plot) { create(:plot, sale_status: "не продается") }

      context "when sale_status is blank" do
        it "returns all plots" do
          is_expected.to match_array [for_sale_plot, not_for_sale_plot]
        end
      end

      context "when sale_status is specified" do
        let(:sale_status) { "продается" }

        it "returns only plots with matching sale_status" do
          is_expected.to match_array [for_sale_plot]
        end
      end
    end

    context "when combining multiple filters" do
      let!(:person) { create(:person) }
      let!(:large_private_for_sale) { create(:plot, number: 40, area: 500, owner_type: "личная собственность", sale_status: "продается") }
      let!(:small_state_not_for_sale) { create(:plot, number: 41, area: 50, owner_type: "государственная собственность", sale_status: "не продается") }

      before do
        create(:owner, person: person, plot: large_private_for_sale)
      end

      context "when filtering by area and owner_type" do
        let(:area_min) { 400 }
        let(:owner_type) { "личная собственность" }

        it "returns plots matching both filters" do
          is_expected.to match_array [large_private_for_sale]
        end
      end

      context "when filtering by person and sale_status" do
        let(:people) { [person.id] }
        let(:sale_status) { "продается" }

        it "returns plots matching both filters" do
          is_expected.to match_array [large_private_for_sale]
        end
      end

      context "when filtering by area, owner_type, and sale_status" do
        let(:area_min) { 40 }
        let(:area_max) { 60 }
        let(:owner_type) { "государственная собственность" }
        let(:sale_status) { "не продается" }

        it "returns plots matching all filters" do
          is_expected.to match_array [small_state_not_for_sale]
        end
      end
    end
  end

  describe ".people_select_options" do
    subject { described_class.people_select_options }

    let!(:person1) { create(:person) }
    let!(:person2) { create(:person) }

    it "returns grouped options for select with people and ids" do
      is_expected.to have_key("Наличие собственника")
      is_expected.to have_key("Участники")
      expect(subject["Наличие собственника"]).to eq [["Любой", "any"], ["Без собственника", "none"]]
      expect(subject["Участники"]).to match_array [[person1.short_name, person1.id], [person2.short_name, person2.id]]
    end
  end

  describe ".sale_statuses" do
    subject { described_class.sale_statuses }

    it "returns plot owner types with blank option" do
      is_expected.to match_array [nil, "не продается", "продается"]
    end
  end

  describe ".owner_types" do
    subject { described_class.owner_types }

    it "returns plot owner types with blank option" do
      is_expected.to match_array [nil, "личная собственность", "государственная собственность"]
    end
  end
end
