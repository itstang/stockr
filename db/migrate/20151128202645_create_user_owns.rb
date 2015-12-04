class CreateUserOwns < ActiveRecord::Migration
  def change
    create_table :user_owns do |t|
      t.string :email
      t.string :symbol
      t.integer :shares
      t.integer :stock_id
    end
  end
end
