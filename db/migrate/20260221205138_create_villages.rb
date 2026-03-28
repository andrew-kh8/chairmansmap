class CreateVillages < ActiveRecord::Migration[8.1]
  def change
    create_table :villages, id: :uuid do |t|
      t.string :name, null: false
      t.string :cadastral_number
      t.multi_polygon :geom, srid: 3857

      t.timestamps
    end

    add_index :villages, :cadastral_number, unique: true
  end
end
