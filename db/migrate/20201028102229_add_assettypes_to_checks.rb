# Copyright 2021 Adevinta

class AddAssettypesToChecks < ActiveRecord::Migration[5.0]
  def change
    add_column :checks, :assettype, :string, null: true
  end
end
