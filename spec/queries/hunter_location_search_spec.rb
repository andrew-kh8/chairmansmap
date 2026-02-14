# typed: false

RSpec.describe HunterLocationSearch do
  subject { described_class.new.call(filters) }

  describe "#call" do
    let(:filters) { {from: date_from, to: date_to, dog: dog_filter, license: license_filter} }
    let(:date_from) { nil }
    let(:date_to) { nil }
    let(:dog_filter) { nil }
    let(:license_filter) { nil }

    context "when filtering by date" do
      let!(:location_jan_1) { create(:hunter_location, date: Date.new(2026, 1, 1)) }
      let!(:location_jan_15) { create(:hunter_location, date: Date.new(2026, 1, 15)) }
      let!(:location_jan_31) { create(:hunter_location, date: Date.new(2026, 1, 31)) }
      let!(:location_feb_15) { create(:hunter_location, date: Date.new(2026, 2, 15)) }

      context "when both date_from and date_to are blank" do
        let(:date_from) { nil }
        let(:date_to) { nil }

        it "returns all hunter locations" do
          is_expected.to match_array [location_jan_1, location_jan_15, location_jan_31, location_feb_15]
        end
      end

      context "when filtering with both date_from and date_to" do
        let(:date_from) { Date.new(2026, 1, 10) }
        let(:date_to) { Date.new(2026, 1, 20) }

        it "returns locations within date range" do
          is_expected.to match_array [location_jan_15]
        end
      end

      context "when filtering with only date_from" do
        let(:date_from) { Date.new(2026, 1, 15) }
        let(:date_to) { nil }

        it "returns locations from date_from onwards" do
          is_expected.to match_array [location_jan_15, location_jan_31, location_feb_15]
        end
      end

      context "when filtering with only date_to" do
        let(:date_from) { nil }
        let(:date_to) { Date.new(2026, 1, 15) }

        it "returns locations up to date_to" do
          is_expected.to match_array [location_jan_1, location_jan_15]
        end
      end

      context "when date_from equals date_to" do
        let(:date_from) { Date.new(2026, 1, 15) }
        let(:date_to) { Date.new(2026, 1, 15) }

        it "returns locations on exact date" do
          is_expected.to match_array [location_jan_15]
        end
      end
    end

    context "when filtering by dog" do
      let!(:location_with_dog) { create(:hunter_location, dog: true) }
      let!(:location_without_dog) { create(:hunter_location, dog: false) }

      context "when dog filter is nil" do
        let(:dog_filter) { nil }

        it "returns all hunter locations" do
          is_expected.to match_array [location_with_dog, location_without_dog]
        end
      end

      context "when dog filter is true" do
        let(:dog_filter) { true }

        it "returns only locations with dog" do
          is_expected.to match_array [location_with_dog]
        end
      end

      context "when dog filter is false" do
        let(:dog_filter) { false }

        it "returns only locations without dog" do
          is_expected.to match_array [location_without_dog]
        end
      end
    end

    context "when filtering by license" do
      let!(:location_with_license) { create(:hunter_location, license: true) }
      let!(:location_without_license) { create(:hunter_location, license: false) }

      context "when license filter is nil" do
        let(:license_filter) { nil }

        it "returns all hunter locations" do
          is_expected.to match_array [location_with_license, location_without_license]
        end
      end

      context "when license filter is true" do
        let(:license_filter) { true }

        it "returns only locations with license" do
          is_expected.to match_array [location_with_license]
        end
      end

      context "when license filter is false" do
        let(:license_filter) { false }

        it "returns only locations without license" do
          is_expected.to match_array [location_without_license]
        end
      end
    end

    context "when combining multiple filters" do
      let!(:jan_dog_license) { create(:hunter_location, date: Date.new(2026, 1, 10), dog: true, license: true) }
      let!(:jan_dog_no_license) { create(:hunter_location, date: Date.new(2026, 1, 15), dog: true, license: false) }
      let!(:jan_no_dog_license) { create(:hunter_location, date: Date.new(2026, 1, 20), dog: false, license: true) }
      let!(:feb_dog_license) { create(:hunter_location, date: Date.new(2026, 2, 10), dog: true, license: true) }

      context "when filtering by date range and dog=true" do
        let(:date_from) { Date.new(2026, 1, 1) }
        let(:date_to) { Date.new(2026, 1, 31) }
        let(:dog_filter) { true }

        it "returns locations matching both filters" do
          is_expected.to match_array [jan_dog_license, jan_dog_no_license]
        end
      end

      context "when filtering by date range and license=true" do
        let(:date_from) { Date.new(2026, 1, 1) }
        let(:date_to) { Date.new(2026, 1, 31) }
        let(:license_filter) { true }

        it "returns locations matching both filters" do
          is_expected.to match_array [jan_dog_license, jan_no_dog_license]
        end
      end

      context "when filtering by all three filters" do
        let(:date_from) { Date.new(2026, 1, 1) }
        let(:date_to) { Date.new(2026, 1, 31) }
        let(:dog_filter) { true }
        let(:license_filter) { true }

        it "returns locations matching all filters" do
          is_expected.to match_array [jan_dog_license]
        end
      end

      context "when filtering by dog and license only" do
        let(:dog_filter) { true }
        let(:license_filter) { true }

        it "returns locations matching dog and license filters" do
          is_expected.to match_array [jan_dog_license, feb_dog_license]
        end
      end
    end
  end
end
