class CreateRanking < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.integer :rank
      t.integer :interval
    end
  end
end
