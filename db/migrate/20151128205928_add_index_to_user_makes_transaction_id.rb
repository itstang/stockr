class AddIndexToUserMakesTransactionId < ActiveRecord::Migration
  def change
  	add_index :user_makes, :transaction_id, unique: true
  end
end
