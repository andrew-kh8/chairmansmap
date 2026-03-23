# typed: false

RSpec.describe "Plots", type: :request do
  describe "GET /plots/check_cadastral_number" do
    let(:cadastral_number) { "11:22:333333:44" }
    let(:params) { {cadastral_number: cadastral_number} }

    context "when Geo::GetPlotCoords returns success" do
      it "returns success status" do
        allow(Geo::GetPlotCoords).to receive(:call).with(cadastral_number).and_return(Typed::Success.new([[1, 2], [3, 4]]))

        get check_cadastral_number_plots_path, params: params

        expect(response).to have_http_status(:ok)
        expect(json_response[:message]).to eq("ok")
      end
    end

    context "when Geo::GetPlotCoords returns failure" do
      it "returns not found status" do
        allow(Geo::GetPlotCoords).to receive(:call).with(cadastral_number).and_return(Typed::Failure.new("Error message"))

        get check_cadastral_number_plots_path, params: params

        expect(response).to have_http_status(:not_found)
        expect(json_response[:message]).to eq("Error message")
      end
    end
  end
end
