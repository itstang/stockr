class CreateTransaction < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :transaction_id
      t.string :type
      t.integer :amount
    end
  end
end
