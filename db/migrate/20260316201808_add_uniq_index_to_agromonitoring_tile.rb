class AddUniqIndexToAgromonitoringTile < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :agromonitoring_tiles, [:village_id, :date, :satellite], unique: true, algorithm: :concurrently
  end
end
