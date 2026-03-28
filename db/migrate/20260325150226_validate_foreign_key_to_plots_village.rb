class ValidateForeignKeyToPlotsVillage < ActiveRecord::Migration[8.1]
  def change
    validate_foreign_key :plots, :villages
  end
end
