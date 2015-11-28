class AddIndexToDividend < ActiveRecord::Migration
  def change
  	add_index :dividends, :symbol, unique: true
  end
end
