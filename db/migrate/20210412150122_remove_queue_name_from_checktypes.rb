# Copyright 2019 Adevinta

class RemoveQueueNameFromChecktypes < ActiveRecord::Migration[5.0]
  def change
    remove_column :checktypes, :queue_name
  end
end
