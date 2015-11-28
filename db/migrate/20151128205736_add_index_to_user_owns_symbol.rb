class AddIndexToUserOwnsSymbol < ActiveRecord::Migration
  def change
  	add_index :user_owns, :symbol, unique: true
  end
end
