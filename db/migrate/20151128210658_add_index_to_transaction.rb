class AddIndexToTransaction < ActiveRecord::Migration
  def change
  	add_index :transactions, :transaction_id, unique: true
  end
end
