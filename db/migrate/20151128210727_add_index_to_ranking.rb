class AddIndexToRanking < ActiveRecord::Migration
  def change
  	add_index :rankings, :rank, unique: true
  end
end
