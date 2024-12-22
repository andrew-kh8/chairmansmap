class AddTimestampToPlots < ActiveRecord::Migration[7.0]
  def change
    add_column :plots, :created_at, :datetime
    add_column :plots, :updated_at, :datetime

    current_date_time = DateTime.current
    Plot.update_all(created_at: current_date_time, updated_at: current_date_time)
  end
end
