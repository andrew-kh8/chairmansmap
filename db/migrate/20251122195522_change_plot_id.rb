class ChangePlotId < ActiveRecord::Migration[7.0]
  def up
    add_column :plots, :id, :uuid
    change_column_default :plots, :id, "gen_random_uuid()"
  end

  def down
    remove_column :plots, :id
  end
end
