# frozen_string_literal: true

class FillPlotsTable < ActiveRecord::Migration[7.0]
  def up
    exec "rails db < db/plots.sql"

    # con = ActiveRecord::Base.connection.raw_connection
    # con.prepare("fill_plots", IO.read("db/plots.sql"))
    # con.exec_prepared("fill_plots")
    # or
    # ActiveRecord::Base.connection.execute(IO.read("db/plots.sql"))
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
