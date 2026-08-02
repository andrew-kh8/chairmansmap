# typed: strict

class AddHeightToVillageJob < ApplicationJob
  sidekiq_options retry: 3

  sig { params(village_id: String).void }
  def perform(village_id)
    village = Village.find(village_id)
    OpenTopo::AddHeightToVillage.new(village).call
  end
end
