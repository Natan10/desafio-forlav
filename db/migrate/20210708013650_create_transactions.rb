class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.decimal :value, precision: 8, scale: 2, null: false
      t.string :status, default: 0, null: false
      t.references :wallet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
