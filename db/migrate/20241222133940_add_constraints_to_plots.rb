class AddConstraintsToPlots < ActiveRecord::Migration[7.0]
  def change
    change_column_null :plots, :geom, false

    change_column_null :plots, :created_at, false
    change_column_null :plots, :updated_at, false
  end
end
