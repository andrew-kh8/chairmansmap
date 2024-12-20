class CreateHunterLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :hunter_locations do |t|
      t.st_point :location, srid: 28406, null: false
      t.datetime :date, null: false
      t.text :description
      t.boolean :license
      t.boolean :dog

      t.timestamps
    end
  end
end
