require "rails_helper"

RSpec.describe CreateHunterLocation do
  subject(:result) { described_class.new.call(params) }

  describe "#call" do
    context "when params are valid" do
      let(:date_str) { "2025-10-05T17:16" }
      let(:description) { "test desc" }
      let(:params) do
        {
          date: date_str,
          license: "0",
          dog: "0",
          description: description,
          location: "44.50812782797782 33.57758084622251"
        }
      end
      let(:hunter_location) { HunterLocation.first }

      it "creates hunter_location" do
        expect { result }.to change { HunterLocation.count }.from(0).to(1)

        expect(hunter_location.date).to eq Time.zone.parse(date_str)
        expect(hunter_location.license).to eq false
        expect(hunter_location.dog).to eq false
        expect(hunter_location.description).to eq description
        expect(hunter_location.location.to_s).to eq "POINT (3737839.2018714654 5544415.830816836)"
      end
    end
  end
end
