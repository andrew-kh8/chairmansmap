class AddTriggerToPlots < ActiveRecord::Migration[8.1]
  def up
    safety_assured do
      execute <<~SQL
        CREATE OR REPLACE FUNCTION update_data_from_plot_data()
        RETURNS TRIGGER AS $$
        BEGIN
          UPDATE plots
          SET
            cadastral_number = NEW.cadastral_number,
            description = NEW.description,
            owner_type = NEW.owner_type,
            sale_status = NEW.sale_status
          WHERE id = NEW.plot_id;
          RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;

        CREATE TRIGGER after_update_move_data
        AFTER INSERT OR UPDATE ON plot_data
        FOR EACH ROW
        EXECUTE FUNCTION update_data_from_plot_data();
      SQL
    end
  end

  def down
    safety_assured do
      execute <<~SQL
        DROP TRIGGER after_update_move_data ON plot_data;
        DROP FUNCTION update_data_from_plot_data();
      SQL
    end
  end
end
