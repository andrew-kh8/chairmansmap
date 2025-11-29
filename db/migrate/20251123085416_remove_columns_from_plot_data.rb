class RemoveColumnsFromPlotData < ActiveRecord::Migration[7.0]
  def up
    remove_column :plot_data, :plot_id
    remove_column :owners, :plot_id

    rename_column :plot_data, :new_plot_id, :plot_id
    rename_column :owners, :new_plot_id, :plot_id

    add_foreign_key :plot_data, :plots, column: :plot_id, index: true, if_not_exists: true
    add_foreign_key :owners, :plots, column: :plot_id, index: true, if_not_exists: true
  end

  def down
    remove_foreign_key :owners, :plots, if_exists: true
    remove_foreign_key :plot_data, :plots, if_exists: true

    rename_column :plot_data, :plot_id, :new_plot_id
    rename_column :owners, :plot_id, :new_plot_id

    add_column :plot_data, :plot_id, :integer
    add_column :owners, :plot_id, :integer
  end
end
