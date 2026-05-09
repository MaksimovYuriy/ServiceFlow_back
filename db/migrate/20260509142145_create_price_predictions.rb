class CreatePricePredictions < ActiveRecord::Migration[7.1]
  def change
    create_table :price_predictions do |t|
      t.integer  :status,        null: false, default: 0
      t.datetime :started_at
      t.datetime :finished_at
      t.text     :error_message
      t.jsonb    :predictions,   null: false, default: []
      t.jsonb    :metrics,       null: false, default: {}

      t.timestamps
    end

    add_index :price_predictions, :created_at, order: { created_at: :desc }
    add_index :price_predictions, :status,
              where: 'status IN (0, 1)',
              unique: true,
              name: 'index_price_predictions_active_singleton'
  end
end
