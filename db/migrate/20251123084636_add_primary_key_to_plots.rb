class AddPrimaryKeyToPlots < ActiveRecord::Migration[7.0]
  def up
    execute "ALTER TABLE plots ADD PRIMARY KEY (id)"
  end

  def down
    execute "ALTER TABLE plots DROP CONSTRAINT plots_pkey"
  end
end
