class RemovePlotData < ActiveRecord::Migration[8.1]
  def up
    drop_table :plot_data
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
