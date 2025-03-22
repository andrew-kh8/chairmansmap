# frozen_string_literal: true

class AddTimestampToPlots < ActiveRecord::Migration[7.0]
  def change
    add_timestamps :plots, null: true

    current_date_time = DateTime.current
    Plot.update_all(created_at: current_date_time, updated_at: current_date_time)

    change_table :plots, bulk: true do
      change_column_null :plots, :created_at, false
      change_column_null :plots, :updated_at, false
    end
  end
end
