class FixPredictionsActiveSingletonIndexes < ActiveRecord::Migration[7.1]
  def up
    remove_index :price_predictions,    name: 'index_price_predictions_active_singleton'
    remove_index :material_predictions, name: 'index_material_predictions_active_singleton'

    execute <<~SQL
      CREATE UNIQUE INDEX index_price_predictions_active_singleton
        ON price_predictions ((true))
        WHERE status IN (0, 1);
    SQL

    execute <<~SQL
      CREATE UNIQUE INDEX index_material_predictions_active_singleton
        ON material_predictions ((true))
        WHERE status IN (0, 1);
    SQL
  end

  def down
    execute 'DROP INDEX IF EXISTS index_price_predictions_active_singleton'
    execute 'DROP INDEX IF EXISTS index_material_predictions_active_singleton'

    add_index :price_predictions, :status,
              where: 'status IN (0, 1)',
              unique: true,
              name: 'index_price_predictions_active_singleton'
    add_index :material_predictions, :status,
              where: 'status IN (0, 1)',
              unique: true,
              name: 'index_material_predictions_active_singleton'
  end
end
