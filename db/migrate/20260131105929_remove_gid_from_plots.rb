class RemoveGidFromPlots < ActiveRecord::Migration[8.1]
  def up
    safety_assured do
      remove_column :plots, :gid
    end
  end

  def down
    add_column :plots, :gid, :serial, null: false
  end
end
