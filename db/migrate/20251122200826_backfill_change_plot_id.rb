class BackfillChangePlotId < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    Plot.unscoped.in_batches(of: 10000) do |relation|
      relation.where(id: nil).update_all("id = gen_random_uuid()")
    end
  end

  def down
  end
end
