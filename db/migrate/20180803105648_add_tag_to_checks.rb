# Copyright 2019 Adevinta

class AddTagToChecks < ActiveRecord::Migration[5.0]
  def change
    add_column :checks, :tag, :string
  end
end
