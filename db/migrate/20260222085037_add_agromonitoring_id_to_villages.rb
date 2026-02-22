class AddAgromonitoringIdToVillages < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_column :villages, :agromonitoring_id, :string
    add_index :villages, :agromonitoring_id, unique: true, algorithm: :concurrently
  end
end
