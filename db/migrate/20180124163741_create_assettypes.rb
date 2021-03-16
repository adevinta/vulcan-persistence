# Copyright 2019 Adevinta

class CreateAssettypes < ActiveRecord::Migration[5.0]
  def change
    create_view :assettypes
  end
end
