RSpec.describe "CAPI GEOS" do
  it "supported CAPI GEOS" do
    expect(RGeo::Geos.capi_supported?).to eq true
  end
end
