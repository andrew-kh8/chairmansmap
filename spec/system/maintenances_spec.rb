# typed: false

RSpec.describe "Maintenances", type: :system do
  context "when maintenance mode is enabled" do
    let(:now) { Time.zone.now }

    before do
      # Mock ENV["MAINTENANCE_MODE"]
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("MAINTENANCE_MODE").and_return(now.to_s)
    end

    it "shows maintenance page" do
      visit maintenance_path

      expect(page).to have_content("Ведутся технические работы")
      expect(page).to have_content("Примерное время завершения технических работ: #{now.strftime("%Y.%m.%d %H:%M")}")
    end
  end

  context "when maintenance mode is disabled" do
    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("MAINTENANCE_MODE").and_return(nil)
    end

    it "redirects to root" do
      visit maintenance_path
      expect(page).to have_current_path(root_path, ignore_query: true)
    end
  end
end
