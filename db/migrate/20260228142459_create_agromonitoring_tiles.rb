class CreateAgromonitoringTiles < ActiveRecord::Migration[8.1]
  def change
    create_table :agromonitoring_tiles, id: :uuid do |t|
      t.datetime :date, null: false
      t.string :satellite, null: false
      t.integer :valid_data_coverage, null: false
      t.float :cloud_coverage, null: false
      t.string :truecolor_url, null: false
      t.string :falsecolor_url, null: false
      t.string :ndvi_url, null: false
      t.string :evi_url, null: false
      t.string :evi2_url, null: false
      t.string :nri_url, null: false
      t.string :dswi_url, null: false
      t.string :ndwi_url, null: false

      t.belongs_to :village, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
  end
end
