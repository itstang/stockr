class CreateDividend < ActiveRecord::Migration
  def change
    create_table :dividends do |t|
      t.string :symbol
      t.integer :dividend
      t.integer :interval
    end
  end
end
