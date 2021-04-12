# Copyright 2019 Adevinta

class AddNameToJobqueues < ActiveRecord::Migration[5.0]
  def change
    add_column :jobqueues, :name, :string, null: true
    add_index :jobqueues, :name
  end
end
