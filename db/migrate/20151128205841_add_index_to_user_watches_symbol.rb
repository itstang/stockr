class AddIndexToUserWatchesSymbol < ActiveRecord::Migration
  def change
  	add_index :user_watches, :symbol, unique: true
  end
end
