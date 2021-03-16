# Copyright 2019 Adevinta

class AddDefaultToJobqueues < ActiveRecord::Migration[5.0]
  def change
    add_column :jobqueues, :default, :boolean, null: false, default: false
  end
end
