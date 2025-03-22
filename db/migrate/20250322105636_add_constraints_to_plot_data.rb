# frozen_string_literal: true

class AddConstraintsToPlotData < ActiveRecord::Migration[7.0]
  def change
    change_table :plot_data, bulk: true do
      add_index :plot_data, :kadastr_number, unique: true
      add_check_constraint :plot_data, "kadastr_number ~ '^\\d{1,2}:\\d{1,2}:\\d{1,7}:\\d{1,9}$'",
                           name: 'kadastr_number_format_regex'
    end
  end
end
