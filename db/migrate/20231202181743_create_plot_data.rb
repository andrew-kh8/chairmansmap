# frozen_string_literal: true

class CreatePlotData < ActiveRecord::Migration[7.0]
  def change
    create_table :plot_data do |t|
      t.references :plot, null: false, primary_key: :number
      t.string :description
      t.string :sale_status
      t.string :owner_type
      t.string :kadastr_number

      t.timestamps
    end
  end
end
