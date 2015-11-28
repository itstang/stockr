class AddIndexToUserMakesEmail < ActiveRecord::Migration
  def change
  	add_index :user_makes, :email, unique: true
  end
end
