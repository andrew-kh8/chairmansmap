# frozen_string_literal: true

class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :middle_name
      t.string :surname
      t.string :tel
      t.string :address
      t.date :birth
      t.date :member_from

      t.timestamps
    end
  end
end
