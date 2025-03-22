# frozen_string_literal: true

class CreateOwners < ActiveRecord::Migration[7.0]
  def change
    create_table :owners do |t|
      t.references :plot, null: false, primary_key: :number
      t.references :person, null: false, foreign_key: true
      t.date :active_from
      t.date :active_to

      t.timestamps
    end
  end
end
