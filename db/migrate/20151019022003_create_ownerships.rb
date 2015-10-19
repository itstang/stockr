class CreateOwnerships < ActiveRecord::Migration
  def change
    create_table :ownerships do |t|
      t.belongs_to :user, index: true
      t.belongs_to :stock, index: true
      t.integer :shares

      t.timestamps null: false
    end
  end
end
