class AddIndexToUserWatchesEmail < ActiveRecord::Migration
  def change
  	add_index :user_watches, :email, unique: true
  end
end
