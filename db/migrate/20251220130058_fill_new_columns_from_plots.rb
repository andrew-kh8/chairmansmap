class FillNewColumnsFromPlots < ActiveRecord::Migration[8.1]
  def up
    safety_assured do
      execute <<~SQL
        UPDATE plots
        SET 
          cadastral_number = plot_data.cadastral_number,
          description = plot_data.description,
          owner_type = plot_data.owner_type,
          sale_status = plot_data.sale_status
        FROM plot_data
        WHERE plots.id = plot_data.plot_id;
      SQL
    end
  end

  def down
    safety_assured do
      execute <<~SQL
        UPDATE plots
        SET
          cadastral_number = NULL,
          description = NULL,
          owner_type = NULL,
          sale_status = NULL;
      SQL
    end
  end
end
