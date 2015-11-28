class AddIndexToProcesses < ActiveRecord::Migration
  def change
  	add_index :processes, :symbol, unique: true
  end
end
