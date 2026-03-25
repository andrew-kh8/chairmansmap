class FillPoltsVillageId < ActiveRecord::Migration[8.1]
  def up
    Village.find_each do |village|
      Plot.where("ST_Contains(?, geom)", village.geom).update_all(village_id: village.id)
    end

    Plot.where(village_id: nil).find_each do |plot|
      ewkt = RGeo::WKRep::WKTGenerator.new(tag_format: :ewkt, emit_ewkt_srid: true).generate(plot.geom)
      sql = Village.sanitize_sql_array(["id, ?::geometry <-> geom as dist", ewkt])
      plot.update!(village_id: Village.select(sql).order(:dist).first.id)
    end
  end

  def down
    Plot.update_all(village_id: nil)
  end
end
