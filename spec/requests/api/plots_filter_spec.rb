# typed: false

require "rails_helper"

RSpec.describe "Api::PlotsFilter", type: :request do
  describe "GET /api/plots/filter" do
    let(:plot_ids) { json_response[:plots] }

    before do
      create(:plot, number: 100, owner_type: "личная собственность", sale_status: "продается")
      create(:plot, number: 200, owner_type: "государственная собственность", sale_status: "не продается")
      create(:plot, number: 300, owner_type: "личная собственность", sale_status: "не продается")

      get api_plots_filter_path, params:
    end

    context "when filter by owner_type" do
      let(:params) { {owner_type: "личная собственность"} }

      it "returns filtered plots by owner_type" do
        expect(response).to have_http_status(200)
        expect(plot_ids).to match_array([100, 300])
      end
    end

    context "when filter by sale_status" do
      let(:params) { {sale_status: "не продается"} }

      it "returns filtered plots by sale_status" do
        expect(response).to have_http_status(200)
        expect(plot_ids).to match_array([200, 300])
      end
    end

    context "when filter by owner_type and sale_status" do
      let(:params) { {owner_type: "личная собственность", sale_status: "не продается"} }

      it "returns combined filtered plots" do
        expect(response).to have_http_status(200)
        expect(plot_ids).to contain_exactly(300)
      end
    end

    context "when there no params" do
      let(:params) { nil }

      it "returns empty hash if no filters provided" do
        expect(response).to have_http_status(200)
        expect(json_response).to be_empty
      end
    end
  end
end
