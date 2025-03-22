# frozen_string_literal: true

class CreatePlots < ActiveRecord::Migration[7.0]
  def up
    create_table :plots, id: false, primaty_key: :number do |t|
      t.serial :gid, null: false
      t.float :area, null: false
      t.float :perimetr, null: false
      t.integer :number, null: false
      t.multi_polygon :geom, srid: 4326

      t.index :number, unique: true
    end
  end

  def down
    drop_table :plots, if_exists: true
  end
end
