class UpdatePlotSrid < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL
      ALTER TABLE plots
      ALTER COLUMN geom TYPE geometry(MultiPolygon, 3857)
      USING ST_SetSRID(geom, 3857);
    SQL
  end

  def down
    execute <<~SQL
      ALTER TABLE plots
      ALTER COLUMN geom TYPE geometry(MultiPolygon, 4326)
      USING ST_SetSRID(geom, 4326);
    SQL
  end
end
