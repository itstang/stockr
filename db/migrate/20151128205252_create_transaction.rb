class CreateTransaction < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string  :transaction_type
      t.string  :email
      t.string  :symbol
      t.integer :shares
      t.integer :amount

      t.timestamps null: false
    end
  end
end
