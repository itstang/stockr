class AddIndexToUserOwnsEmail < ActiveRecord::Migration
  def change
  	add_index :user_owns, :email, unique: true
  end
end
