class CreateUserWatches < ActiveRecord::Migration
  def change
    create_table :user_watches do |t|
      t.string :email
      t.string :symbol
    end
  end
end
