class CreateProcesses < ActiveRecord::Migration
  def change
    create_table :processes do |t|
      t.string :symbol
      t.integer :news_sentiment
      t.integer :social_sentiment
      t.string :name
    end
  end
end
