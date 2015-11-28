class CreateUserMakes < ActiveRecord::Migration
  def change
    create_table :user_makes do |t|
      t.string :email
      t.integer :transaction_id
    end
  end
end
